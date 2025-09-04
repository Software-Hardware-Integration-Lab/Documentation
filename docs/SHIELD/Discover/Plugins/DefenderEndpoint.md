# Defender for Endpoint

When interpreting the MDE plugin's results in the `License Data` table, a result that has a 0 count of available licenses could mean that no license is present even if a record is present that represents the license.
This is because the license data is coming from MDE and not the licensing system. We do this because MDE could be enabled without a corresponding license. E.g. Defender for Cloud for Servers.

## Licenses Checked

Please note that due to the way Microsoft makes this data available, the license report format uses the mappings found in the [Reserved Principals](../Reference/Reserved-Principals.md) page.

- Defender for Business (SMB) - `bfc1bbd9-981b-4f71-9b82-17c35fd0e2a4`
- Defender for Endpoint P1 - `292cc034-7b7c-4950-aaf5-943befd3f1d4`
- Defender for Endpoint P2 - `871d91ec-ec1a-452b-a83f-bd76c7d770ef`
- Defender Vulnerability Management Standalone - `36810a13-b903-490a-aa45-afbeb7540832`
- Defender Vulnerability Management Addon - `36810a13-b903-490a-aa45-afbeb7540832`

## Permissions/Roles Required

- [X] Global Reader
    - Count of active users and devices
- [X] Security Administrator
    - Count of available licenses

## Execution Sequence

The following diagram shows the plugin execution Sequence.

## Diagram

```mermaid
sequenceDiagram
    activate DiscoverEngine
    DiscoverEngine->>DiscoverEngine: Import DefenderForEndpoint
    DiscoverEngine->>DefenderForEndpoint: getAssignmentData(ref: LicenseReport)
    activate DefenderForEndpoint
    DefenderForEndpoint->>DefenderForEndpoint: Import RestEngine, ProgressBar, SettingsEngine
    DefenderForEndpoint->>DefenderForEndpoint: init Progress Bar
    DefenderForEndpoint->>DefenderForEndpoint: init Available License URI
    DefenderForEndpoint->>DefenderForEndpoint: init Consumed License URI
    activate SettingsEngine
    DefenderForEndpoint->>SettingsEngine: Show Progress Bar
    activate RestEngine
    DefenderForEndpoint->>RestEngine: Call async sccQuery(available license Uri)
    DefenderForEndpoint->>SettingsEngine: Update Progress Bar
    break if the available license sccQuery fails
        DefenderForEndpoint->>SettingsEngine: Remove Progress Bar
        DefenderForEndpoint-->>DiscoverEngine: Return      
    end

    DefenderForEndpoint->>RestEngine: Call async sccQuery(Consumed License Uri)
    DefenderForEndpoint->>SettingsEngine: Update Progress Bar
    break if the consumed license sccQuery fails
        DefenderForEndpoint->>SettingsEngine: Remove Progress Bar
        DefenderForEndpoint-->>DiscoverEngine: Return      
    end
    RestEngine-->>DefenderForEndpoint: available License query results
    RestEngine-->>DefenderForEndpoint: consumed license query results
    deactivate RestEngine

    DefenderForEndpoint->>DefenderForEndpoint: init data structure for consumed licenses
    loop foreach consumed license
        DefenderForEndpoint->>DefenderForEndpoint: Detect the current SKU and add its values to the data structure
    end

    alt if Vulnerability Management licenses have been purchased
        DefenderForEndpoint->>DefenderForEndpoint: Increment stand-alone licenses by P1 Users count
        DefenderForEndpoint->>DefenderForEndpoint: Increment stand-alone licenses by Smb Users count
        DefenderForEndpoint->>DefenderForEndpoint: Increment add-on licenses by P2 Users count
    end

    DefenderForEndpoint->>DefenderForEndpoint: LicenseReport: Set MDE P1 User service assignment count
    DefenderForEndpoint->>DefenderForEndpoint: LicenseReport: Set MDE P2 User service assignment count
    DefenderForEndpoint->>DefenderForEndpoint: LicenseReport: Set MDfB User service assignment count
    DefenderForEndpoint->>DefenderForEndpoint: LicenseReport: Set MDE P1 User service assignment count

    DefenderForEndpoint->>SettingsEngine: Remove Progress Bar
    deactivate SettingsEngine
    DefenderForEndpoint-->>DiscoverEngine: Return
    deactivate DefenderForEndpoint
    DiscoverEngine->>DiscoverEngine:Save LicenseReport
    deactivate DiscoverEngine
```
