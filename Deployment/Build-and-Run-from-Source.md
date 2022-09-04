To build the project from source, all you need is Node.JS installed.   
If you want to generate the EXE and Linux binaries too, then you will also need the PKG package installed globally.

Quick Links:
* [Prep the Files](#prep-the-files)
* [Build the Server](#build-the-server)
* [Build the UI](#build-the-ui)
* [(Optional) Build the Windows Installers](#optional-build-the-windows-installers)
* [Final Remarks](#final-remarks)

---

### Prep the Files

1. Clone/Download the project
```batchfile
git clone https://github.com/microsoft/Privileged-Security-Management.git
```
or using GitHub Desktop:   
<img src="https://user-images.githubusercontent.com/5030490/170869202-1a69c8a0-645f-4b24-a6c4-ff4aed48a459.png" alt="Screenshot of GitHub Desktop's clone repo dialog box with the project's git URL in one of the text fields." width="600" />


2. Install the latest LTS build of Node.JS: https://nodejs.org/en/download/
3. (Optional) Install [PKG](https://www.npmjs.com/package/pkg) to be able to generate EXE/Linux Bin files:
```batchfile
npm install -g pkg
```

---

### Build the Server

Since the server and UI are built in separate folders, you can technically run the API server without a UI. Because of this, there are extra build steps to follow to build the entire project as you will need to build the Server and the UI separately.   
You can build the server or the UI in any order.

1. Change your working directory to the `Server` directory:
```batchfile
cd /Server
```

2. Install the dependencies:
```batchfile
npm install
```

3. Compile the servers files:
```batchfile
npm run build
```

Now you can run the server 😎   
You can start the server by running:
```batchfile
npm start
```

---

### Build the UI

The user interface is a standalone API client. The server [doesn't technically need one to operate](https://github.com/microsoft/Privileged-Security-Management/wiki/Environmental-Variables-Reference#PSM_Headless). The server has been configured to serve a UI from the bin folder next to the server core API files.

1. Change your working directory to the `User-Interface` directory: 
```batchfile
cd /User-Interface
```

2. Install the UI's dependencies:
```batchfile
npm install
```

3. Compile the UI files:
```batchfile
npm run build
```
---

### (Optional) Build the Windows Installers

The Windows installers are built using the [Advanced Installer](https://www.advancedinstaller.com/) tool from Caphyon.   
<img src="https://user-images.githubusercontent.com/5030490/170872220-f7de7645-ec20-46df-846a-d74f685bbab5.png" alt="Advanced Installer Logo" width="500" />

An `Enterprise` or higher [license](https://www.advancedinstaller.com/purchase.html) is required as custom dialogs are used to keep the `MSI` and `EXE` installers on brand. Since this is an open-source project, Caphyon has very generously granted us an `Architect` license to build our installers via Ci/CD with [GitHub Actions](https://github.com/microsoft/Privileged-Security-Management/blob/main/.github/workflows/Build-Binaries.yml).

To Build the `EXE` and `MSI` installers, you can run the below CLI command in advanced installer.   
The `EXE` version needs to be built first as the `EXE` build process will delete any existing `MSI` as an `MSI` object is generated as part of the `EXE` build process and subsequently deleted for resource clean up reasons. So, by building the `EXE` first then the `MSI`, you will have both in the `dist` folder.

Before building the Installers, the raw Windows `EXE` needs to be generated from PKG as the Advanced Installer system is configured to package it up.

> Note:
> The Advanced Installer executables are located here by default on a 64-Bit Windows computer:   
> `C:\Program Files (x86)\Caphyon\Advanced Installer 19.5\bin\x86`

1. Set the working directory to the `Server` folder:
```batchfile
cd /Server
```

2. Build the raw EXE:
```batchfile
npx pkg .
```

3. Set the working directory to the Project's Root:
```batchfile
cd ..
```

4. Build the EXE Installer:
```batchfile
AdvancedInstaller.com /build ".\Privileged Security Management.aip" -buildslist "EXE"
```

5. Build the MSI Installer:
```batchfile
AdvancedInstaller.com /build ".\Privileged Security Management.aip" -buildslist "MSI"
```

---

### Final Remarks

You are done!   
The UI and the server's files have been compiled and are ready to operate.   
Starting the server will serve the UI at the servers root. You can start the server by running the below command in the `Server` directory:
```batchfile
npm start
```
Don't forget to configure the [environmental variables](https://github.com/microsoft/Privileged-Security-Management/wiki/Environmental-Variables-Reference) if you are running without a [Managed Identity](https://github.com/microsoft/Privileged-Security-Management/wiki/Configure-Managed-Identity) as you will need to authenticate via an App Registration.