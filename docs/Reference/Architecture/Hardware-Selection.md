# Hardware Selection

To ensure optimal performance and security, the MSM application has specific hardware recommendations based on the different security classes and modes of operation. While consistency in hardware selection is recommended, the choice of OEM is flexible and can vary based on customer preference.

## ESM and SSM Modes

For ESM (Enterprise Security Class) and SSM (Specialized Security Class) modes, the hardware requirements are as follows:

- **Operating System**: Windows 10 or later certified hardware
- **RAM**: Recommended minimum of 16GB (for a better user experience and future proofing)
- **Graphics**: NVIDIA graphics card (optional, for GPU-intensive workloads)

We recommend using Microsoft Surface for Business devices or Lenovo devices for ESM and SSM modes. These devices offer reliable performance and align with the security principles of MSM. It is important to note that AMD graphics cards are not recommended due to poor driver quality. Ultimately the choice of OEM is flexible based on customer preference.

!!! note
    Regularly check for hardware updates and firmware patches from the device manufacturers to maintain the highest level of compatibility, performance, and security for your ESM and SSM deployments.

## PSM Mode

PSM (Privileged Security Class) mode requires even more stringent hardware requirements to ensure the highest level of security. In addition to the Windows 11 operating system, the following specifications are recommended:

- **Secure Core Certified Hardware**: Microsoft Secure Core Certified Windows 11 devices
- **Processor**: Intel Core i7 or Ryzen 7 equivalent
- **RAM**: Recommended 32GB, hard minimum: 16GB
- **Storage**: At least 256GB NVMe drive

PSM mode operates on devices with Microsoft Secure Core Certification, which provides enhanced hardware and firmware security features. These devices are designed with additional security measures, such as D-RTM (Dynamic Root of Trust Measurement) or S-RTM (Static Root of Trust Measurement), secure boot in Microsoft-only mode, and other firmware-level protections.

For a broad overview on Microsoft Secure Core Certified PCs, including a list of compatible devices, please visit the [Microsoft Windows 11 Secured Core Computers](https://www.microsoft.com/en-us/windows/business/windows-11-secured-core-computers) page.

For a list of secure core certified devices from Microsoft or Lenovo, you can refer to these links:

- Microsoft Surface: [Microsoft Surface Devices](https://www.microsoft.com/en-us/windows/business/devices?col=microsoft&col=securedcorepc)
- Lenovo: [Lenovo Secure Core Certified PCs](https://www.microsoft.com/en-us/windows/business/devices?col=lenovo&col=securedcorepc)

## Conclusion

Selecting the right hardware for MSM deployment is crucial to ensure optimal performance and security. Depending on the security class and mode of operation, the hardware requirements may vary. We recommend using Microsoft Surface or Lenovo devices for ESM and SSM modes. Microsoft Secure Core certified Windows 11 devices are required for PSM mode.

Choosing performant hardware is important for security because happy users means less shadow IT. Dissatisfaction leads to end users bringing in their own systems to solve their issues rather than using corporate systems.

For further guidance on hardware selection or compatibility, please refer to the provided links and consult the official documentation for the respective hardware manufacturers.

## See Also

- [Lifecycle Management Overview](/Getting-Started/Usage-Guide/Lifecycle-Management/): Learn more about the lifecycle management features of MSM and how it simplifies the management of user and device objects.
- [Commissioning a New Device](/Getting-Started/Usage-Guide/Lifecycle-Management/Device/Commission/): Step-by-step guide on commissioning (adopting) a new device using MSM.
- [Decommission a Managed Device](/Getting-Started/Usage-Guide/Lifecycle-Management/Device/Decommission/): Step-by-step guide on decommissioning (removing) a device that is currently being managed by MSM.
