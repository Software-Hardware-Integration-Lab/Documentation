# Overview:
This version roadmap document is a place to see the future vision for this project.   
Features that are indented are dependent on the parent item to be completed before their implementation.

Synchronous features are the major features that will be designated by the version of the project.   
E.g. version `1.0.0` of the project will have PAW Lifecycle Management capabilities.   

Asynchronous features could be implemented at any time and will not bump a major version.   
E.g. additional documentation.

---

### Synchronous new features:
1. [Lifecycle Management](#Lifecycle-Management)
2. [User Interface](#User-Interface)
3. [Auto Deployment](#Auto-Deployment) 
4. [Silo Model](#Silo-Model)
5. [In App User Roles](#In-App-User-Roles)
6. [On-Prem Support](#On-Prem-Support)
7. [Updater](#Updater)
8. [Configuration Health Check](#Policy-Health-Check)

### Asynchronous new features:
* [Continuous Integration](#Continuous-Integration)
  * [SDL Tooling](#SDL-Tooling)
  * [Automated Tests](#Automated-Tests)
* [Additional Deployment Methods](#Additional-Deployment-Methods)
* [Documentation](#Documentation)
* [OpenAPI Integration](#OpenAPI-Integration)

---

## Lifecycle Management

Lifecycle management handles the below operations:
* Onboarding new hardware to PAW
  * Selected device will be added to the `PAW devices` security group root level (non-user assigned).
* Decommissioning PAW
  * Issue the wipe command to the PAW and remove it from the PAW devices SG hierarchy.
* Assignment of user to PAW
  * Create a SG in the PAW Dev hierarchy, move the PAW from the root SG into the new unique child SG and apply user rights assignment for the new user
* Reassignment of a PAW to a new user
  * Issue wipe command, update SG membership, update policies, and send sync command to the PAW
* Un-assignment of PAW
  * issue the wipe command and move it out of the child SG back to the root hierarchy for assignment to a new user, then issue the sync command to remove the user rights assignment asap.

---

## User Interface

The UI will be designed with Microsoft Fluent Design to feel more like a modern Microsoft application.

User interface will use a local version of https://www.microsoft.com/design/fluent/#/web.   
That is, it will not web-request the resources from the external source. It will be hosted locally within the app to minimize potential exploits.

The UI will be as simple as possible to make it easy to manage and implement the PAW/silo models.

---

## Auto Deployment

Auto deployment is a feature where PAW does not exist already, it simplifies the initial deployment of PAW, which is usually extremely difficult to pull off.

The goal is to have a single button to click on the UI that will auto deploy the entire PAW architecture in less than a minute.   
Things that would be deployed include:
* Security Baselines
* Compliance Policy
* Configuration Policies
* Update Policies
* Enrollment Policies
* Conditional Access
* Credential Partitioning
* Silo model (when it is implemented in the app, won't be initially available)

---

## Silo Model

The silo model is a way to manage Just Enough Administration (JEA) and Just In-Time (JIT) Permissions as well as software availability on the device.   
The silo model will include its own hierarchy of SGs with two verticals, one for permeant configurations and apps that get applied to the identity and the other is the just in time elevation to be able to leverage the use of the apps and configs that get applied.

Not all workloads support JIT.   
E.G. Serial connection to networking systems (not SSH).   
This usually requires specialized software and Endpoint Manager can't deploy the app as soon as the user gets elevated, by default endpoint manager checks for changes to configuration every 8 hours.
In these cases acceptable risk needs to be evaluated/re-evaluated as these workloads reduce security as permissions would be permanently assigned, which comes with less auditability.

---

## In App User Roles

Users can be configured to have access to only certain sections of the app.   
This is also useful for delegating control over certain logical containers such as silos to certain groups.   
This helps with IAM logical scalability, not just the hosting platform scalability.

Three levels of delegation are supported:
* Owner
  * Can read/write and change permissions
* Contributor
  * Can read/write
* Reader
  * Can read

---

## On-Prem Support

On-prem support is critical for todays world as the majority of organization run some sort of on-prem directory system.   
To support these frequent scenarios, Windows Virtual Desktop (WVD) Integration is integrated into the PAW management app to make it easy to bridge the cloud/on-prem gap.

WVD will be domain joined to on-prem to provide trust and managed using MS Endpoint Manager to easily apply configurations/security to the WVD clusters.

---

## Updater

As the PAW architecture changes, it is necessary to keep the management app up to date with the latest versions.   
Since the PAW management app runs on critical systems, automated updates are not going to be included to reduce the risk of an easy supply chain attack.    It will be up to the admins to press check for update and to push the download/install button.   
This will leave updates in the hands of the admins.

A banner will be displayed at the top of the app if an update check has not been performed in a while to encourage keeping the app updated.
Updates will not be enforced.

---

## Configuration Health Check

Configuration drift is a thing and the configuration health check is an option that has the app scan the current deployed model to ensure that the base configuration is still present.   
After the scan is complete, it will display a report in the admin console stating missing policies.   
On the report page, check boxes will be present on each item for the admin to select which drift they want to remediate. This allows for custom modifications that should not be corrected by the health check.   
The health check will not put banners anywhere stating there are policies missing as some orgs may have alternative mitigations in-place to cover the missing policies.

This check will auto run after an update is installed as new versions will frequently have changes to the architecture.

The health check could be turned into a secure score in the future for continuous evaluation. This will need to be debated with the dev team and advisor teams.

---

## Continuous Integration

Continuous Integration (Ci) is used to run checks on the code, such as running the build command to ensure that the code compiles.   
Ci will also be the foundation of running the SDL toolset against the code.   
It will show when code breaks sooner than with manual testing and will provide valuable insights into the security of the application, catching issues before they are released to the stable code.

---

## SDL Tooling

[Security Development Lifecycle (SDL)](https://microsoft.com/sdl) is crucial to reducing the risk of any app. This app is no exception.   
Checks like static and dynamic code analysis, vulnerability assessments, and auto pen-testing are to be implemented as part of the Ci pipeline/actions.

---

## Automated Tests

Automated tests are critical for quickly validating if a change breaks something.   
This will reduce bugs and manual testing.

This will be integrated into the Ci/CD pipeline.

---

## Additional Deployment Methods

Ease of deployment to make deployment accessible to everyone is a corner stone of this project.   
It is best to run it in Azure but [SPA Architecture](https://aka.ms/spa) is critical for everyone no matter where you are deployed.   

Planned Deployment Methods:
* Azure Marketplace (Preferred)
* Docker Hub
* MSI/MSIX installer
* Snap Installer
* DEB Installer
* RPM Installer
* Source Code/Self Deploys

---

## Documentation

Documentation that is easy to follow like SCEPman's:   
https://docs.scepman.com/

Documentation that is complete.   
All features documented, even the dev/debug interfaces.

---

## OpenAPI Integration

Since the app can also act as an API, auto documentation of the API and a way to easily consume the API is critical for other projects to integrate into.   
OpenAPI will be the standard adopted to facilitate ease of API Consumption.   
https://www.openapis.org/