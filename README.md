# Sitecore XP Uninstaller

## Introduction
This repository contains a PowerShell script designed to automate the uninstallation process of Sitecore XP 9.3 and later versions. Whether you're cleaning up after a development project or preparing for a fresh installation, this script will help you remove Sitecore from your system efficiently.

## Features
- Removes IIS configurations associated with Sitecore backend, Identity Server, and xConnect sites.
- Deletes entries related to Sitecore from the hosts file.
- Stops and deletes Windows services associated with Sitecore.
- Drops databases related to Sitecore from SQL Server.
- Removes the root directory of the Sitecore instance from the file system.
- Optionally removes Solr service and associated files and configurations.

## How to Use
1. Clone or download the repository to your local machine.
2. Open PowerShell with administrative privileges.
3. Navigate to the directory where the script is located.
4. Modify the script variables (if necessary) to match your environment.
5. Run the script by executing `.\Uninstaller-SitecoreXP.ps1`.
6. Wait for the script to complete.
7. Verify that Sitecore has been successfully uninstalled from your system.

## Prerequisites
- PowerShell (version 5.1 or later)
- Administrative privileges

## Contributions
Contributions to improve this script are welcome! Feel free to fork the repository, make your changes, and submit a pull request. Please ensure that your contributions align with the project's goals and maintain code quality.

## Support
For any questions, issues, or feature requests, please open an [issue](https://github.com/yourusername/Sitecore-XP-Uninstaller/issues) on GitHub.

