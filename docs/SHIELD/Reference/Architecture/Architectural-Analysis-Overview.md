
The SHIELD system runs a full architectural analysis by gathering tenant data, runs a parallel analysis on all configuration items, and saves the results. Afterward, tenant data is compared to the baseline configuration, and a report is generated. This overview provides a more detailed outline of this process.

## Input Validation & Locking
When the scan is deployed, the system checks if there is already an analysis in progress. 

- If there is no scan occurring, the system locks the engine to begin the analysis and moves on the next step.
- If there is a scan is in progress, the button is disabled to prevent concurrent operations. 

## Progress Bar
Once the analysis begins, a progress bar displays the status of three different steps:

1. **Retrieving Tenant Metadata**
2. **Analyze Architecture** (During which a sub-progress bar is displayed for each baseline configuration, along with the status of the analysis)
    1. Gathering data from tenant
    2. Comparing tenant data to the baseline configuration
    3. Building report
    4. Status
        - **Done** - Displayed once the analysis is finalized and there are no errors reported.
        - **Error** - Displayed if a critical error is hit during any of the three previous checkpoints.
3. **Saving Architecture Report**

### 1. Retrieving Tenant Metadata
The system gathers metadata, such as users and devices, associated with the current tenant and architecture, via the `initializeArchitectureReport()` function. The data is then stored in the system, so it can be analyzed in the next step. 

#### Information Stored
Data is stored in one of two ways:

1. **Raw data** for all Conditional Access policy configurations is retrieved from the Azure tenant. This information is cached in application memory for the duration of the analysis. This is automatically cleared in the step immediately before the engine lock is released.
2. **Summary data** of the architectural analysis report is retained in a digital repository according to our data retention policy. The data is mostly Universally Unique Identifiers (UUIDs), numbers, and dates. This includes:
    - A unique identifier that represents each run of the architectural analysis
    - Tenant ID under analysis
    - Total users in the tenant
    - Total guest users in the tenant
    - Total member users in the tenant
    - Total devices associated with the tenant
    - The principal name associated with the user used to authenticate into the tenant being audited
    - User account used to store and report the architecture report to SHI
    - Timestamp when the record was created
    - Timestamp when the record was last updated
    - A list of UUIDs corresponding to users and their associated SHIELD baseline configuration items
        - The list also includes a string, specifying if a tenant policy was found that matches the baseline policy, classified as either 'full' or 'partial'. User identifiers with no 'full' or 'partial' matches are excluded.

### 2. Analyze Architecture
All the SHIELD baseline configurations are added to a list, and each configuration is analyzed independently via the `analyzeArchitecture()` function. During this step the system will:

- Retrieve live data from the tenant (e.g., Microsoft Graph)
- Compare tenant data to baseline configuration
- Record discrepancies, matches, and assignments
- Report findings back to the deploy engine

### 3. Saving the Architecture Report
Once all the configuration items have been analyzed, a report is created via the `saveArchitectureReport()` function. This serializes and saves the results of the analysis, including findings, discrepancies, and additional metadata for later review and reporting.

## Finalization
Once the system is finished with the analysis and the report has been saved, the timestamp of the last analysis is updated. Next, the graph data cache is cleared, and the engine is unlocked. If the system ran into any errors during the process, those are also logged. 

## Summary Table

|            | Responsibility |
|------------|----|
|`analyze`|	Begins the entire Architectural Analysis process, analyzing all configuration items in the architecture |
|`analyzeArchitecture()`|	An asynchronous analyzation method called on each item in the configuration list |
|`configurationItemList`|	A list of all the configuration items that were gathered during the retrieval phase |
|`DeployEngine`|	The engine that powers the system running the Architectural Analysis |
|`initializeArchitectureReport()`|	Gathers and stores metadata about the current tenant and architecture |
|`isDeploying`|	Checks if the system is running a scan or deploying a policy |
|`Promise.all`|	Analysis operations are collected into a list and executed in parallel |
|`saveArchitectureReport()`|	Saves the results of the analysis and stores the results |
|`writeDebugInfo`|	Logs errors that occur during analysis |

---

## Conditional Access Policies

To get a better understanding of the analysis process and how the system compares customer policies to baseline policies, let's look at a specific policy. For Conditional Access Policies, the system analyzes a single Conditional Access Policy configuration item via the `analyzeConditionalAccessPolicy` function, a specialized analysis function. There are three steps to analyzing a Conditional Access Policy:

1. **Type Validation** - The system checks if the configuration item is a valid instance or not. 
2. **Create New Instance** - A new instance of `CspmConditionalAccess` is created, passing the configuration item and `graphBeta` flag. 
3. **Delegation to Internal Analysis** - Data is gathered and analyzed via the `analyzeConditionalAccessPolicyInternal()` function.

### Delegation to Internal Analysis

#### Locking
During this step, the system will check if there is already an analysis in progress. If not, the system locks the engine to begin the analysis.

#### Progress Bar
Once the analysis begins, a progress bar displays the status of each step.

#### Data Fetch

The system calls the `getCustomerTenantGraphData()` function to analyze the current Conditional Access Policies from Microsoft Graph.

#### Comparison

The `compareConditionalAccessPolicy()` function validates the URL path and calls the `compareConditionalAccessPolicies()` function, which does the following:

- Scans the baseline configuration
- Compares each policy to the baseline
- Assess the degree of match, either 'full', 'partial', or 'none'
    - **Full Coverage**: All of in scope are fully covered by the policy. The policy matches the baseline for every user.
    - **Partial Coverage**: A percentage of users in scope are covered by the policy, but the policy only partially matches the baseline for those users. 
    - **No Coverage**: No users are covered by the policy. The policy does not provide any baseline coverage. 
    - **Unassigned**: Users are not assigned to the deployed policy. 
- Builds an assignment and exclusion list for reporting

#### Reporting

A report is created via the `sendConfigurationMatchAssessmentToDeployEngine()` function to record the results found in the previous steps.

#### Error Handling & Unlocking

Errors are logged and updated in the progress bar, and the lock is then released.

## Summary Table

|	| Responsibility |
|---|----------------|
|`analyzeConditionalAccessPolicy`|	Analyzes a single Conditional Access policy configuration item
|`analyzeConditionalAccessPolicyInternal()`|	Analyzes the Conditional Access Policies internally
|`compareConditionalAccessPolicies()`|	Scans the baseline configuration, compares each policy to the baseline, assesses the degree of match, and builds a list for reporting
|`compareConditionalAccessPolicy()`|	Validates the URL path and prepares the system to compare Conditional Access Policies
|`ConfigurationItem.analyzeArchitecture()`|	Delegates each configuration item to the correct analyzer
|`CspmConditionalAccess`|	Implements the logic for fetching, comparing, and reporting Conditional Access policies
|`DeployEngine.analyze()`|	Orchestrates analysis for all configuration items in the architecture
|`getCustomerTenantGraphData()`|	Pulls in the current Conditional Access Policies from Microsoft Graph
|`sendConfigurationMatchAssessmentToDeployEngine()`|	Records the results of the analysis and creates an architecture report