## Dev Env Setup

1. Clone the Repository

2. Set up .env file

    ```
    git clone https://github.com/Software-Hardware-Integration-Lab/URL-Shortener

    AZURE_TENANT_ID="op://Your 1Password/Secret Reference/TenantID"
    AZURE_CLIENT_ID="op://Your 1Password/Secret Reference/Client ID"
    AZURE_CLIENT_SECRET="op://Your 1Password/Secret Reference/Client Secret"
    SUS_Debug="true"
    SUS_Local="true"
    ```

3. **Install dependencies:** ```npm install```

4. **Build the project** ```npm run build:Prod```

5. **Migrate up the dev DB:** ```npm run migrate:Up:Db:Dev```

6. (Optional) Place or symlink compiled static UI files in the ```./bin/src/core/router/routes/UI``` folder

## Pre-Commit

1. **Lint the project:** ```npm run lint```

2. **Build project:** ```npm run build:Prod```

## Request Flow (Typical Create Redirect)

1. **Client obtains access token** with the required scopes.

2. **POST body is validated** for shape and required fields before logic executes.

3. The redirect engine enforces the following policies:
   - **Banned term screening** to prevent misuse or brand/legal risks.
   - **Domain allowlist constraints** to ensure only approved destinations are used.
   - **Uniqueness check** to verify the short path is available.

4. If validation passes, the **record is created** and persisted.

5. The **response returns the canonical redirect object**, including metadata and resolution details.
