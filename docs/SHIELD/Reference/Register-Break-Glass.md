# Register Break Glass Accounts with SHIELD

To deploy a policy with SHIELD, there must be two break glass accounts in SHIELD's break glass security group.
The first section of this guide explains how to create a break glass account if needed.
The last section of this guide explains how to add existing break glass accounts to the SHIELD security group.

## Create Accounts

This section lists the steps to create a single break glass account.
If you need to create two break glass accounts, you must go through the process below twice.
Once you have two break glass accounts, you can follow the steps in the [last section](#register-break-glass-accounts-with-shield) to add the break glass accounts to SHIELD's security group.
For more information about properly generating, printing, and storing break glass accounts, see the [Break Glass Overview](./Break-Glass-Overview.md) page.

If necessary, repeat the steps below until you have two break glass accounts in your tenant.

!!! failure "WARNING, HERE BE DRAGONS!"
    Please read the [Break Glass Overview](./Break-Glass-Overview.md) page before preceding with the below.
    Failure to secure your break glass account will lead to organization wide compromise.
    If you have ANY questions about the process, please reach out to your SHI or SHIELD representative.

### Create Account

1. Sign in to Microsoft Entra: [https://entra.microsoft.com/](https://entra.microsoft.com/){:target="_blank"}
2. In the left navigation bar, click **Users** (typically under **Entra ID**).
3. At the top of the table, click **+ New User**, and select **Create new user** from the drop-down menu.
4. Enter the name of the break glass group in the **User principal** name textbox (e.g., emergency, mchammer, etc.).
5. Enter a **Display name** (e.g., Emergency Mode, MC Hammer, etc.).
6. Click on the **Assignments** tab.
7. Click **+ Add role**.
8. Select the **Global Administrator** role and click **Select**.
9. Click on the **Review + create** button.
10. Click on the **Create** button.

### Reset Password and Login

1. Click on the name of the newly created break glass account. If you don't see the name of the break glass account, refresh the page.
2. Make note of the **User Principal Name** in your break glass instruction set.
3. Click **Reset password** at the top of the page.
4. Click **Reset password**. A temporary password is displayed. Click on the copy icon next to the temporary password and paste it somewhere secure.
5. Open a fresh in-private/incognito tab and navigate to <https://myaccount.microsoft.com>
6. Log into your break glass account using the email address and temporary password you copied previously.
7. You will be prompted to update your password by entering the temporary password and a new password. For more information about generating a password, see [Passwords](./Break-Glass-Overview#passwords).
8. Store the new password in a safe location.

## Add break glass accounts to security group

Complete the below for each Break Glass account your tenant has.

1. Sign in to Microsoft Entra: [https://entra.microsoft.com/](https://entra.microsoft.com/){:target="_blank"}
2. In the left navigation bar, click **Users** (typically under **Entra ID**).
3. Check the box next to each break glass account you would like to add to the security group.
4. At the top of the table, click **Edit**, and select **Add to group** from the drop-down menu.
5. Check the box next to the group `SHIELD - Break Glass 🚨` and click **Select**.
6. A message will display confirming your break glass accounts have been successfully added to the group.

!!! note
    You must add at least two break glass accounts to the SHIELD security group in order to deploy a policy.
