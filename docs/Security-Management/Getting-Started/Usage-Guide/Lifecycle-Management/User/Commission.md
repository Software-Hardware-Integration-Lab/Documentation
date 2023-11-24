# Commission

The lifecycle management system can bring users into and out of management for non-privileged objects.  
For privileged users, it creates a new cloud only user account that is correlated to an account that is used as a template for various settings such as name and UPN.

## Process

1. Select your security class from the top bar.

2. Press the `➕ Add User` button.

3. Select the set of users that you would like to add to management.

    ![Screenshot of the unmanaged user picker with a single user "Michal Schmidt" selected.](../../../../assets/Images/Screenshots/Select-Unmanaged-User-Light.png#only-light){ loading=lazy width="300" }
    ![Screenshot of the unmanaged user picker with a single user "Michal Schmidt" selected.](../../../../assets/Images/Screenshots/Select-Unmanaged-User-Dark.png#only-dark){ loading=lazy width="300" }

    !!! note
        If running in the privileged security context, this will create new account based on the accounts you selected.
        In all other modes, this will bring the user into management.

4. Press the `Select` button at the bottom of the selection panel to start the management process.

5. Privileged Only: Make note of the new temporary credentials and securely deliver them to their respective account holder(s).

    ![Screenshot of the temporary credential dialog for the new privileged user "Michal.Schmidt@example.com", showing the new user's new User Principal Name and temporary (expired) password.](../../../../assets/Images/Screenshots/Temporary-Credential-Dialog-Light.png#only-light){ loading=lazy }
    ![Screenshot of the temporary credential dialog for the new privileged user "Michal.Schmidt@example.com", showing the new user's new User Principal Name and temporary (expired) password.](../../../../assets/Images/Screenshots/Temporary-Credential-Dialog-Dark.png#only-dark){ loading=lazy }

## See Also

- [User Commission Workflow Reference](../../../../Reference/Architecture/Diagrams/User-Commission.md)
