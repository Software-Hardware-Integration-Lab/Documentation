# Add Break Glass Accounts to Security Group


A break glass account, or emergency access account, is a highlight privileged, unlicensed, emergency access mechanism used to regain access to critical resources that can be used to recover systems. Typically, when standard administrative accounts are unavailable, due to outages, conditional access misconfiguration, Multi-Factor Authentication (MFA) failures, or account lockouts.
To deploy a policy with SHIELD, there must be two break glass accounts in the SHIELD security group. The first section of this guide explains how to add existing break glass accounts to the SHIELD security group. The last section of this guide explains how to create a break glass account if needed.

---


This section lists the steps to add existing break glass accounts to the SHIELD security group. If you do not have any break glass accounts configured or you would like to create new ones, see the [Create a break glass account](/SHIELD/Reference/Break-Glass-Group/#create-a-break-glass-account) section below.

## Add break glass accounts to security group

1. Sign in to Microsoft Entra: [https://entra.microsoft.com/](https://entra.microsoft.com/){:target="_blank"}
2. In the left navigation bar, click **Users** (typically under **Entra ID**).
3. Check the box next to each break glass account you would like to add to the security group.
4. At the top of the table, click **Edit**, and select **Add to group** from the drop-down menu.
5. Check the box next to the group "SHIELD - Break Glass 🚨" and click **Select**.
6. A message will display confirming your break glass accounts have been successfully added to the group.

**Note**: You must add at least two break glass accounts to the SHIELD security group in order to deploy a policy.

---


This section lists the steps to create a single break glass account. If you need to create two break glass accounts, you must go through the process below twice. Once you have two break glass accounts, you can follow the steps in the section above to add the break glass accounts to your SHIELD security group. For more information about properly generating, printing, and storing break glass accounts, see [Break Glass Accounts](/SHIELD/Reference/Break-Glass-Overview/).

## Create a break glass account

- Create Account
    1. Sign in to Microsoft Entra: [https://entra.microsoft.com/](https://entra.microsoft.com/){:target="_blank"}
    2. In the left navigation bar, click **Users** (typically under **Entra ID**).
    3. At the top of the table, click **+ New User**, and select **Create new user** from the drop-down menu.
    4. Enter the name of the break glass group in the **User principal** name textbox (e.g., breakglass1, breakglass2, etc.).
    5. Enter a **Display name** (e.g., Break Glass One, Break Glass Two, etc.).
    6. Click on the **Assignments** tab.
    7. Click **+ Add role**.
    8. Select the **Global Administrator** role and click **Select**.
    9. Click on the **Review + create** button.
    10. Click on the **Create** button.
- Reset Password and Login
    1. Click on the name of the newly created break glass account. If you don't see the name of the break glass account, refresh the page.
    2. Click on the copy icon next to the **User principal** name and paste the break glass email address somewhere secure.
    3. Click **Reset password** at the top of the page.
    4. Click **Reset password**. A temporary password is displayed. Click on the copy icon next to the temporary password and paste it somewhere secure.
    5. Click on the account name in the top right corner and click **Sign in with a different account** or **sign out**. 
        - **Note**: If you click **sign out**, you may need to specify which Microsoft Entra account you wish to sign out of. 
    6. Click **+ Use another account** and log into your break glass account using the email address and temporary password you copied previously.
    7. You will be prompted to update your password by entering the temporary password and a new password. For more information about generating a password, see [Passwords](/SHIELD/Reference/Break-Glass-Overview/#passwords).
    8. Follow the steps until you have logged into your newly created break glass account.
- If necessary, repeat the steps above until you have two break glass accounts in your tenant.