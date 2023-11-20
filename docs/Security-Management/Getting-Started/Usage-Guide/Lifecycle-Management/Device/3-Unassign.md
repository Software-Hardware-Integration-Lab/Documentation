# Unassign User

Privileged devices (PAWs) use credential partitioning to prevent unexpected credentials from being stored or used on them.  
User Assignments achieves this requirements on the PAWs. User assignments allows only the specified user(s) to log onto the specific privileged device.

Un-assigning a user removes that user(s) from being allowed to sign into the specified workstation.
The user un-assignment process also removes the requested user(s) from the Hyper-V admin role.

## Process

1\. Select the `Privileged` security class from the top bar.

2\. Press the `Manage` button in the `User Assignments` column.

3\. Select the list of users that you would like to un-assign from the PAW.

![Screenshot of the User Assignment page with a single user "Fritz Collier" selected and the unassign button enabled.](../../../../assets/Images/Screenshots/Select-User-to-Unassign-Light.png#only-light){ loading=lazy }
![Screenshot of the User Assignment page with a single user "Fritz Collier" selected and the unassign button enabled.](../../../../assets/Images/Screenshots/Select-User-to-Unassign-Dark.png#only-dark){ loading=lazy }

4\. Press the `🗑️ Unassign User` Button.

5\. Review and validate that the information is correct on the unassign confirmation box.

![Screenshot of the confirmation dialog showing the list of selected users, and the options to continue with the unassign or cancel the process.](../../../../assets/Images/Screenshots/Confirm-Unassign-Light.png#only-light){ loading=lazy }
![Screenshot of the confirmation dialog showing the list of selected users, and the options to continue with the unassign or cancel the process.](../../../../assets/Images/Screenshots/Confirm-Unassign-Dark.png#only-dark){ loading=lazy }

6\. Press the `Unassign` button to start the automated unassign process.

!!! warning
    If no users are left in the list of assigned users for a privileged device, a wipe command will be issued.

## See Also

- [Device Unassign Workflow Reference](../../../../Reference/Architecture/Diagrams/Device-Unassign.md)
