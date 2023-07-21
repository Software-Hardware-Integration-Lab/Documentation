# Commission

The lifecycle management system can bring devices into and out of management following a security best practices onboarding and offboarding depending on the security class selected.

This guide will walk the security admin through the process of commissioning new managed devices.

!!! note "Privileged Hardware"
    For requirements and best practices on privileged hardware, please see the [Hardware Selection](/Reference/Architecture/Hardware-Selection/) documentation.

## Process

1\. Select your security class from the top bar.

!!! info
    The default security level is set to Privileged. You will need to change it for Specialized or Enterprise.

2\. Press the `➕ Commission Device` button.

3\. Select the set of devices that you would like to add to management.

![Screenshot of the unmanaged devices picker with a single device selected.](/assets/Images/Screenshots/Select-Unmanaged-Device-Light.png#only-light){ loading=lazy width="300" }
![Screenshot of the unmanaged devices picker with a single device selected.](/assets/Images/Screenshots/Select-Unmanaged-Device-Dark.png#only-dark){ loading=lazy width="300" }

!!! warning "Privileged Device Commissioning"
    When a `privileged` device is commissioned, a wipe/reset command is issued to the selected device set if they are present in Intune.  
    This is to preserve clean source as much as possible on potentially unclean hardware.  
    Other security classes are unaffected.

4\. Press the `Select` button at the bottom of the selection drawer to start the commissioning process.

## See Also

- [Hardware Selection](/Reference/Architecture/Hardware-Selection/)
- [Device Onboarding Workflow Reference](/Reference/Architecture/Diagrams/Device-Commission/)
