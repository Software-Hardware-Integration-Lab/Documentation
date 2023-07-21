# Assign User

Privileged devices (PAWs) use credential partitioning to prevent unexpected credentials from being stored or used on them.  
User Assignments achieves this requirements on the PAWs. User assignments allows only the specified user(s) to log onto the specific privileged device.

Assigning a user sets that user as allowed to sign into the specified workstation. All other users will be blocked.  
The user assignment process also adds the requested user(s) to the Hyper-V admin role so as to not need user account control elevation when working with VMs.

## Process

1\. Select the `Privileged` security class from the top bar.

2\. Press the `Manage` button in the `User Assignments` column.

3\. Press the `➕ Assign User` button.

4\. Select the list of users that you would like to be able to log into the device.

![Screenshot of the privileged user picker with a single user "Fritz Collier" selected.](/assets/Images/Screenshots/Select-User-to-Assign-Light.png#only-light){ loading=lazy width="300" }
![Screenshot of the privileged user picker with a single user "Fritz Collier" selected.](/assets/Images/Screenshots/Select-User-to-Assign-Dark.png#only-dark){ loading=lazy width="300" }

5\. Press the Select button at the bottom of the selection drawer to start the assignment process.

!!! note
    Currently when assigning, the process replaces any existing assignment(s).

    If you would like to add to the current assignment list, you will have to select the already assigned user(s) and add the additional ones you want.

    We have the behavior slated to change in an upcoming release. The road-mapped behavior will not replace the assignment list, it will add the user to the existing list.

!!! warning
    When assigning multiple users and there is already a set of users, if none of the users exist on both the set of new and old users, a device wipe command will be issued.
