# Reserved Principal IDs

Some services can't correlate their principals and will report a number of consumed licenses. The below IDs are reserved for those incompatible apps.
The IDs are not a principal. They represent the type of license being reported about. These IDs are not to be correlated outside of the License Analytics system as they are not guaranteed to be globally unique across all products from all vendors.

## Defender for Endpoint

- `00000000-0000-0000-0000-000000000101` - Defender for Endpoint Plan 1 - Users
- `00000000-0000-0000-0000-000000000102` - Defender for Endpoint Plan 1 - Devices (multiply the available licenses by 5 to get the total available count)
- `00000000-0000-0000-0000-000000000103` - Defender for Endpoint Plan 2 - Users
- `00000000-0000-0000-0000-000000000104` - Defender for Endpoint Plan 2 - Devices (multiply the available licenses by 5 to get the total available count)
- `00000000-0000-0000-0000-000000000105` - Defender for Business - Users
- `00000000-0000-0000-0000-000000000106` - Defender for Business - Devices

## Defender Vulnerability Management

In addition to the principal IDs using the below, the available licenses uses the below as the same service plan ID is used for both the standalone and add-on license and they need to be differentiated.

- `00000000-0000-0000-0000-000000000201` - Defender Vulnerability Management - Standalone
- `00000000-0000-0000-0000-000000000202` - Defender Vulnerability Management - Add-on

## Defender for Identity

- `00000000-0000-0000-0000-000000000300` - Number of principals detected
