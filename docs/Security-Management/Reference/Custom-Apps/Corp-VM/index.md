# Overview

The Corp VM app creates a unique VM in Hyper-V named 'CorpVM' and places a shortcut on all user's desktops.
The app also tunes the processor(s) to match optimal performance of the specific hardware that it is hosted on.

The Corp VM is a standard computer build (recommended to be ESM or SSM class) that is traditionally hosted in a Privileged Access Workstation (PAW).

## Ease Of Use

Since a Corp VM isn't strictly necessary, it is more of a convenience factor because PAWs are unable to perform normal productivity tasks like browsing, documents editing/creation, email, etc.

The primary goal of the CorpVM is to eliminate the need for a secondary computer to perform productivity tasks.

The Corp VM allows for the majority of productivity tasks on the PAW hardware. Video acceleration is lacking in a lot of cases.

## Data Storage

Data is stored persistently so that even across host restarts, the data is still present. This differs from Windows Sandbox where the data is wiped after the sandbox is closed.

The max size of the hard disk is defaulted to `1TB`.
The default type of disk is `Dynamically Expanding` so that `1TB` of disk space is not required to operate the VM. As data is stored or programs are installed, the disk will automatically grow to store the required data.
This can be increased later if necessary by editing the Disk from in Hyper-V and selecting a larger size.

## Security

The host operating system is protected by a hypervisor boundary and hypervisors are traditionally very difficult to break out of due to their relative simplicity.

Because of this Moot, Inc. considers this to be an acceptable risk architecture to host a guest VM of a lower security class and active encourages the usage of them to improve user reception of the PAW devices.

Organizations are free to remove the CorpVM functionality if they wish, as it is not a dependency of any other part of the MSM manged architecture.

## Architecture

The Corp VM app uses an untouched Windows 11 Pro image straight from Microsoft. When the system boots, the VM will go through out of box experience like a standard computer would and it is expected that the end user would fill out the correct set of info to get it operational.

The Corp VM is not `Autopilot` enabled and does not have an `unattend.xml` configuration(s) out of the box.

## Deployment

The Corp VM app is distributed as an MSI file with accompanying CAB files that is intended to be deployed via Intune.
This can either be set as required or optional.
