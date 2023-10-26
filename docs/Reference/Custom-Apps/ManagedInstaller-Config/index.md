# Overview

The Managed Installer configuration is designed to configure Microsoft AppLocker Managed Installer (MI) rules on installation.

Some of the example configurations that the app performs include managing the Microsoft Edge Updater, and the Microsoft Teams Updater. By utilizing the power of MI, the app can ensure that only approved applications are installed and run on the system, thereby enhancing security and reducing the risk of unauthorized access or data breaches.

## Value Proposition

Overall, this app is a valuable tool for any organization or individual seeking to tighten their security measures and control the applications that are installed on their systems. With its ability to configure and manage MI, it provides a comprehensive solution for managing application security, and its automatic removal of all associated configurations upon uninstall ensures that there are no lingering security holes left behind.

!!! warning
    Upon removal of the config app **all** AppLocker configurations will be removed. This means that any configurations that were set up by the app during installation, as well as any that were previously in place, will be removed when the app is uninstalled.

    This behavior will be updated in the future to remove only managed rules.
