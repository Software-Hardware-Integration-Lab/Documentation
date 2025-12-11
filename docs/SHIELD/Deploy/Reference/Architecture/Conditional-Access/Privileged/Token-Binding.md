# Token Binding

## Description

This policy is designed to prevent token theft from Microsoft Exchange Online (EXO) and SharePoint Online (SPO) clients by enforcing secure session controls for privileged users.

## Why It's Important

This policy protects against token theft by binding access tokens to secure sessions, ensuring attackers cannot reuse stolen tokens to bypass SHIELD identity and access controls.

## Recommendations

- **Communicate** the policy change and its impact to affected users. 
- **Stage** the rollout by piloting with a small, controlled group. 
- **Test** functionality and user experience across supported platforms. 
- **Maintain** a rollback plan to quickly respond to any issues. 
- **Enforce** the policy broadly once validated and stable.

## License Requirements

- P2 License

## Learn More

- [Token Protection in Microsoft Entra Conditional Access](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-token-protection){:target="_blank"}

<br>

---
