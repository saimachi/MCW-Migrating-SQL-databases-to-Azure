![Microsoft Cloud Workshops](https://github.com/Microsoft/MCW-Template-Cloud-Workshop/raw/main/Media/ms-cloud-workshop.png "Microsoft Cloud Workshops")

<div class="MCWHeader1">
Migrating SQL databases to Azure
</div>

<div class="MCWHeader2">
Hands-on lab step-by-step guide
</div>

<div class="MCWHeader3">
October 2021
</div>

Information in this document, including URL and other Internet Web site references, is subject to change without notice. Unless otherwise noted, the example companies, organizations, products, domain names, e-mail addresses, logos, people, places, and events depicted herein are fictitious, and no association with any real company, organization, product, domain name, e-mail address, logo, person, place or event is intended or should be inferred. Complying with all applicable copyright laws is the responsibility of the user. Without limiting the rights under copyright, no part of this document may be reproduced, stored in or introduced into a retrieval system, or transmitted in any form or by any means (electronic, mechanical, photocopying, recording, or otherwise), or for any purpose, without the express written permission of Microsoft Corporation.

Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in this document. Except as expressly provided in any written license agreement from Microsoft, the furnishing of this document does not give you any license to these patents, trademarks, copyrights, or other intellectual property.

The names of manufacturers, products, or URLs are provided for informational purposes only and Microsoft makes no representations and warranties, either expressed, implied, or statutory, regarding these manufacturers or the use of the products with any Microsoft technologies. The inclusion of a manufacturer or product does not imply endorsement of Microsoft of the manufacturer or product. Links may be provided to third party sites. Such sites are not under the control of Microsoft and Microsoft is not responsible for the contents of any linked site or any link contained in a linked site, or any changes or updates to such sites. Microsoft is not responsible for webcasting or any other form of transmission received from any linked site. Microsoft is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement of Microsoft of the site or the products contained therein.

© 2021 Microsoft Corporation. All rights reserved.

Microsoft and the trademarks listed at <https://www.microsoft.com/en-us/legal/intellectualproperty/Trademarks/Usage/General.aspx> are trademarks of the Microsoft group of companies. All other trademarks are property of their respective owners.

**Contents**

<!-- TOC -->

- [Migrating SQL databases to Azure hands-on lab step-by-step](#migrating-sql-databases-to-azure-hands-on-lab-step-by-step)
  - [Abstract and learning objectives](#abstract-and-learning-objectives)
  - [Overview](#overview)
  - [Solution architecture](#solution-architecture)
  - [Requirements](#requirements)
  - [Exercise 1: Perform database assessments](#exercise-1-perform-database-assessments)
    - [Task 1: Connect to the WideWorldImporters database on the SqlServer2008 VM](#task-1-connect-to-the-wideworldimporters-database-on-the-sqlserver2008-vm)
    - [Task 2: Create an Azure Migrate Project](#task-2-create-an-azure-migrate-project)
    - [Task 3: Assess migration to Azure SQL Database](#task-3-assess-migration-to-azure-sql-database)
    - [Task 4: Assess migration to Azure SQL Managed Instance](#task-4-assess-migration-to-azure-sql-managed-instance)
  - [Exercise 2: Migrate the database to SQL MI](#exercise-2-migrate-the-database-to-sql-mi)
    - [Task 1: Create an SMB network share on the SqlServer2008 VM](#task-1-create-an-smb-network-share-on-the-sqlserver2008-vm)
    - [Task 2: Change MSSQLSERVER service to run under the sqlmiuser account](#task-2-change-mssqlserver-service-to-run-under-the-sqlmiuser-account)
    - [Task 3: Create a backup of the WideWorldImporters database](#task-3-create-a-backup-of-the-wideworldimporters-database)
    - [Task 4: Retrieve SQL MI and SQL Server 2008 VM connection information](#task-4-retrieve-sql-mi-and-sql-server-2008-vm-connection-information)
    - [Task 5: Create a service principal](#task-5-create-a-service-principal)
    - [Task 6: Create and run an online data migration project](#task-6-create-and-run-an-online-data-migration-project)
    - [Task 7: Perform migration cutover](#task-7-perform-migration-cutover)
    - [Task 8: Verify database and transaction log migration](#task-8-verify-database-and-transaction-log-migration)
  - [Exercise 3: Update the web application to use the new SQL MI database](#exercise-3-update-the-web-application-to-use-the-new-sql-mi-database)
    - [Task 1: Assess the Application with the Data Access Migration Toolkit (Optional)](#task-1-assess-the-application-with-the-data-access-migration-toolkit-optional)
    - [Task 2: Deploy the web app to Azure](#task-2-deploy-the-web-app-to-azure)
    - [Task 3: Update App Service configuration](#task-3-update-app-service-configuration)
  - [Exercise 4: Integrate App Service with the virtual network](#exercise-4-integrate-app-service-with-the-virtual-network)
    - [Task 1: Generate and export certificates for Point-to-Site](#task-1-generate-and-export-certificates-for-point-to-site)
    - [Task 2: Set point-to-site addresses](#task-2-set-point-to-site-addresses)
    - [Task 3: Configure VNet integration with App Services](#task-3-configure-vnet-integration-with-app-services)
    - [Task 4: Open the web application](#task-4-open-the-web-application)
  - [Exercise 5: Improve database security posture with Data Discovery and Classification and Azure Defender for SQL](#exercise-5-improve-database-security-posture-with-data-discovery-and-classification-and-azure-defender-for-sql)
    - [Task 1: Configure Data Discovery and Classification](#task-1-configure-data-discovery-and-classification)
    - [Task 2: Enable Azure Defender for SQL](#task-2-enable-azure-defender-for-sql)
    - [Task 3: Review an Azure Defender for SQL Vulnerability Assessment](#task-3-review-an-azure-defender-for-sql-vulnerability-assessment)
  - [Exercise 6: Enable Dynamic Data Masking](#exercise-6-enable-dynamic-data-masking)
    - [Task 1: Enable DDM on credit card numbers](#task-1-enable-ddm-on-credit-card-numbers)
    - [Task 2: Apply DDM to email addresses](#task-2-apply-ddm-to-email-addresses)
  - [Exercise 7: Use online secondary for read-only queries](#exercise-7-use-online-secondary-for-read-only-queries)
    - [Task 1: View Leaderboard report in the WideWorldImporters web application](#task-1-view-leaderboard-report-in-the-wideworldimporters-web-application)
    - [Task 2: Update read-only connection string](#task-2-update-read-only-connection-string)
    - [Task 3: Reload Leaderboard report in the web app](#task-3-reload-leaderboard-report-in-the-web-app)
  - [After the hands-on lab](#after-the-hands-on-lab)
    - [Task 1: Delete Azure resource groups](#task-1-delete-azure-resource-groups)
    - [Task 2: Delete the wide-world-importers service principal](#task-2-delete-the-wide-world-importers-service-principal)

<!-- TOC -->

# Migrating SQL databases to Azure hands-on lab step-by-step

## Abstract and learning objectives

In this hands-on lab, you implement a proof-of-concept (PoC) for migrating an on-premises SQL Server 2008 R2 database into Azure SQL Managed Instance (SQL MI). You perform assessments to reveal any feature parity and compatibility issues between the on-premises SQL Server 2008 R2 database and Azure's managed database offerings. You then migrate the customer's on-premises gamer information web application and database into Azure, with minimal downtime. Finally, you enable some of the advanced SQL features in SQL MI to improve security and performance in the customer's application.

At the end of this hands-on lab, you will be better able to implement a cloud migration solution for business-critical applications and databases.

## Overview

Wide World Importers (WWI) is the developer of the popular Tailspin Toys brand of online video games. Founded in 2010, the company has experienced exponential growth since releasing the first installment of their most popular game franchise to include online multiplayer gameplay. They have since built upon this success by adding online capabilities to the majority of their game portfolio.

Adding online gameplay has dramatically increased their games' popularity, but the rapid increase in demand for their services has made supporting the current setup problematic. To facilitate online gameplay, they host gaming services on-premises using rented hardware. For each game, their gaming services setup consists of three virtual machines running the gaming software and five game databases hosted on a single SQL Server 2008 R2 instance. In addition to the dedicated gaming VMs and databases, they also host shared authentication and gateway VMs and databases. At its foundation, WWI is a game development company made up primarily of software developers. The few dedicated database and infrastructure resources they do have are struggling to keep up with their ever-increasing workload.

WWI is excited to learn more about how migrating to the cloud can improve its overall processes and address the concerns and issues with its on-premises setup. They are looking for a proof-of-concept (PoC) for migrating their gaming VMs and databases into the cloud. With an end goal of migrating their entire service to Azure, the WWI engineering team is also interested in understanding better what their overall architecture will look like in the cloud. They maintain their gamer information database, `WideWorldImporters`, on an on-premises SQL Server 2008 R2 database. This system is used by gamers to update their profiles, view leader boards, purchase game add-ons, and more. Since this system helps drive revenue, it is considered a business-critical application and needs to be highly available. They are aware that SQL Server 2008 R2 is beyond the end of support and are looking at options for migrating this database into Azure. They have read about some of the advanced security and performance tuning options that are available only in Azure and would prefer to migrate the database into a platform-as-a-service (PaaS) offering, if possible. WWI uses the Service Broker feature of SQL Server for messaging within its `WideWorldImporters` database. This functionality enables several critical processes, and they cannot afford to lose these capabilities when migrating their operations database to the cloud. They have also stated that, at this time, they do not have the resources to rearchitect the solution to use an alternative message broker.

## Solution architecture

Below is a diagram of the solution architecture you implement in this lab. Please study this carefully to understand the whole of the solution as you are working on the various components.

![This solution diagram includes a virtual network containing SQL MI in an isolated subnet, along with a JumpBox VM and Database Migration Service in a management subnet. The MI Subnet displays both the primary managed instance and a read-only replica, which is accessed by reports from the web app. The web app connects to SQL MI via a subnet gateway and point-to-site VPN. The web app is published to App Services using Visual Studio 2019. Online data migration is conducted from the on-premises SQL Server to SQL MI using the Azure Database Migration Service, which reads backup files from an SMB network share.](./media/preferred-solution-architecture.png "Preferred Solution diagram")

The solution begins with using the Microsoft Data Migration Assistant (DMA) to perform assessments of feature parity and compatibility of the on-premises SQL Server 2008 R2 database. DMA assessments are performed against Azure SQL Database (Azure SQL DB) and Azure SQL Managed Instance (SQL MI). The goal is to migrate the `WideWorldImporters` database into an Azure PaaS offering with minimal or no application changes. After completing the assessments and reviewing the findings, the SQL Server 2008 R2 database is migrated into SQL MI using the Azure Database Migration Service's online data migration option. The online data migration feature of DMS allows the database migration to happen with minimal downtime, using a backup and transaction logs stored in an SMB network share.

The web app is deployed to an Azure App Service Web App using Visual Studio 2019. Once the migrated database's cutover is complete, VNet integration for the `WideWorldImporters` web application is configured. This integration allows the web app to connect to the SQL MI VNet through a virtual network gateway using a point-to-site VPN. The web app's connection strings are updated to point to the new SQL MI database.

In SQL MI, several features of Azure SQL are examined. Azure Defender for SQL is enabled, and Data Discovery and Classification is used to understand better the data and potential compliance issues with data in the database. The Azure Defender for SQL Vulnerability Assessment tool is used to identify potential security vulnerabilities and problems in the database. Those issues listed in the assessment report are used to mitigate one finding by enabling Transparent Data Encryption in the database. Dynamic Data Masking (DDM) is used to prevent sensitive data from appearing when querying the database. Finally, Read Scale-out is used to point reports on WWI's web app to a read-only secondary, allowing reporting to occur without impacting the primary database's performance.

## Requirements

- Microsoft Azure subscription must be pay-as-you-go or MSDN.
  - Trial subscriptions will not work.
- A virtual machine configured with Visual Studio Community 2019 or higher (setup in the Before the hands-on lab exercises).
- **Important**: You must have sufficient rights within your Azure AD tenant to create an Azure Active Directory application and service principal and assign roles on your subscription to complete this hands-on lab.

## Exercise 1: Perform database assessments

Duration: 20 minutes

In this exercise, you use the Microsoft Data Migration Assistant (DMA) to perform assessments on the `WideWorldImporters` database. You create two assessments: one for SQL DB and a second for SQL MI. These assessments provide reports about any feature parity and compatibility issues between the on-premises database and the Azure-managed SQL database service options.

> DMA helps you upgrade to a modern data platform by detecting compatibility issues that can impact database functionality in your new version of SQL Server or Azure SQL Database. DMA recommends performance and reliability improvements for your target environment and allows you to move your schema, data, and uncontained objects from your source server to your target server. To learn more, read the [Data Migration Assistant documentation](https://docs.microsoft.com/sql/dma/dma-overview?view=azuresqldb-mi-current).

### Task 1: Connect to the WideWorldImporters database on the SqlServer2008 VM

In this task, you perform some configuration for the `WideWorldImporters` database on the SQL Server 2008 R2 instance to prepare it for migration.

1. Navigate to the [Azure portal](https://portal.azure.com) and select **Resource groups** from the Azure services list.

   ![Resource groups is highlighted in the Azure services list.](media/azure-services-resource-groups.png "Azure services")

2. Select the hands-on-lab-SUFFIX resource group from the list.

   ![Resource groups is selected in the Azure navigation pane, and the "hands-on-lab-SUFFIX" resource group is highlighted.](./media/resource-groups.png "Resource groups list")

3. In the list of resources for your resource group, select the SqlServer2008 VM.

   ![The SqlServer2008 VM is highlighted in the list of resources.](media/resource-list-sqlserver2008.png "Resource list")

4. On the SqlServer2008 VM blade in the Azure portal, select **Overview** from the left-hand menu, and then select **Connect** and **RDP** on the top menu, as you've done previously.

   ![The SqlServer2008 VM blade is displayed, with the Connect button highlighted in the top menu.](./media/connect-vm-rdp.png "Connect to SqlServer2008 VM")

5. On the Connect with RDP blade, select **Download RDP File**, then open the downloaded RDP file.

6. Select **Connect** on the Remote Desktop Connection dialog.

   ![In the Remote Desktop Connection Dialog Box, the Connect button is highlighted.](./media/remote-desktop-connection-sql-2008.png "Remote Desktop Connection dialog")

7. Enter the following credentials when prompted, and then select **OK**:

   - **Username**: `sqlmiuser`
   - **Password**: The password provided in the ARM template (default is `Password.1234567890`)

   ![The credentials specified above are entered into the Enter your credentials dialog.](media/rdc-credentials-sql-2008.png "Enter your credentials")

8. Select **Yes** to connect if prompted the remote computer's identity cannot be verified.

   ![In the Remote Desktop Connection dialog box, a warning states the remote computer's identity cannot be verified and asks if you want to continue anyway. At the bottom, the Yes button is circled.](./media/remote-desktop-connection-identity-verification-sqlserver2008.png "Remote Desktop Connection dialog")

9. Once logged in, open **Microsoft SQL Server Management Studio 17** (SSMS) by entering "SQL Server" into the search bar in the Windows Start menu and selecting **Microsoft SQL Server Management Studio 17** from the search results.

   ![SQL Server is entered into the Windows Start menu search box, and Microsoft SQL Server Management Studio 17 is highlighted in the search results.](media/start-menu-ssms-17.png "Windows start menu search")

10. In the SSMS **Connect to Server** dialog, enter **SQLSERVER2008** into the Server name box, ensure **Windows Authentication** is selected, and then select **Connect**.

    ![The SQL Server Connect to Search dialog is displayed, with SQLSERVER2008 entered into the Server name and Windows Authentication selected.](media/sql-server-connect-to-server.png "Connect to Server")

11. Once connected, verify you see the `WideWorldImporters` database listed under databases.

    ![The WideWorldImporters database is highlighted under Databases on the SQLSERVER2008 instance.](media/wide-world-importers-database.png "WideWorldImporters database")

### Task 2: Create an Azure Migrate Project

In this Task, you will use Azure Migrate to create a project to consolidate your assessment results for Azure SQL Database and Azure SQL Managed Instance migrations from on-premises SQL Server.

Azure Migrate is useful for large migrations of apps, servers, and data, as it assists migration teams to decide the optimal resource SKUs for the Azure landing zone and explore the relationships between on-premises applications and data. To learn more about this powerful tool, consult the [documentation.](https://docs.microsoft.com/azure/migrate/)

1. In the global search at the top of the [Azure Portal](portal.azure.com), query for and select **Azure Migrate**.

   ![This image highlights Azure Migrate in the global search results.](./media/select-azure-migrate-portal.png "Selecting Azure Migrate from global search")

2. Select **Assess and migrate databases** on the **Get started** page.

   ![This image highlights the Assess and migrate databases button on the Get started page of Azure Migrate.](./media/azure-migrate-in-portal.png "Assess and migrate databases button in Azure Migrate")

3. Select **Create project**. On the **Create project** page, provide the following information:

   - **Subscription**: Use the Azure Subscription you provisioned your lab resources in
   - **Resource group**: Select the resource group you selected during the ARM template deployment
   - **Project**: Use `wwi-sql-migrate-SUFFIX` as the project name
   - **Geography**: Select the nearest geographic region from the dropdown

   ![This image highlights the above parameters in the Create project page.](./media/azure-migrate-project-details.png "Create project page parameters")

4. Select **Create**.

5. After the project provisions, observe the **Assessment tools** and **Migration tools** sections. We will be using the mentioned **Data Migration Assessment** tool to determine whether Azure SQL Database or Azure SQL Managed Instance is the preferred target for WWI's migration.

   ![This image highlights the Assessment tools section of the Databases (only) page in Azure Migrate.](./media/azure-migrate-dma-mention.png "Assessment tools box in Azure Migrate")

### Task 3: Assess migration to Azure SQL Database

In this task, you use the Microsoft Data Migration Assistant (DMA) to assess the `WideWorldImporters` database against Azure SQL Database (Azure SQL DB). The assessment provides a report about any feature parity and compatibility issues between the on-premises database and the Azure SQL DB service.

1. On the SqlSever2008 VM, launch DMA from the Windows Start. It should appear highlighted, as you just installed it. Otherwise, you can access it using the Windows menu by typing **data migration** into the search bar and selecting **Microsoft Data Migration Assistant** in the search results.

   ![In the Windows Start menu, "data migration" is entered into the search bar, and Microsoft Data Migration Assistant is highlighted in the Windows start menu search results.](media/windows-start-menu-dma.png "Data Migration Assistant")

2. In the DMA dialog, select **+** from the left-hand menu to create a new project.

   ![The new project icon is highlighted in DMA.](media/dma-new.png "New DMA project")

3. In the New project pane, set the **Project name** to `ToAzureSqlDb`.

4. Ensure the following options are set with the correct values. Then, select **Create**.

   - **Project type**: Select **Assessment**.
   - **Assessment type**: Select **Database Engine**.
   - **Source server type**: Select **SQL Server**.
   - **Target server type**: Select **Azure SQL Database**.

   ![The new project settings for doing a SQL Server to Azure SQL Database migration assessment are entered into the dialog.](media/dma-new-project-to-azure-sql-db.png "New project settings")

5. On the **Options** screen, ensure **Check database compatibility** and **Check feature parity** are checked and select **Next**.

   ![Check database compatibility and check feature parity are checked on the Options screen.](media/dma-options.png "DMA options")

6. On the **Select sources** screen, enter the following into the **Connect to a server** dialog that appears on the right-hand side:

   - **Server name**: Select **SQLSERVER2008**.
   - **Authentication type**: Select **SQL Server Authentication**.
   - **Username**: Enter `WorkshopUser`
   - **Password**: Enter `Password.1234567890`
   - **Encrypt connection**: Check this box.
   - **Trust server certificate**: Check this box.

7. Select **Connect**.

   ![In the Connect to a server dialog, the values specified above are entered.](media/dma-connect-to-a-server.png "Connect to a server")

8. On the **Add sources** dialog that appears, check the box for **WideWorldImporters** and select **Add**.

   ![The WideWorldImporters box is checked on the Add sources dialog.](media/dma-add-sources.png "Add sources")

9. Select **Start Assessment**.

   ![Start assessment](media/dma-start-assessment-to-azure-sql-db.png "Start assessment")

10. Review the migration assessment to determine the possibility of migrating to Azure SQL DB.

    ![For a target platform of Azure SQL DB, feature parity shows one feature that is not supported in Azure SQL DB. The Service broker feature is selected on the left and on the right Service Broker feature is not supported in Azure SQL Database is highlighted.](media/dma-feature-parity-service-broker-not-supported.png "Database feature parity")

    > **Note**: The DMA assessment for migrating the `WideWorldImporters` database to a target platform of Azure SQL DB reveals features in use that are not supported. These features, including Service broker, prevent WWI from migrating to the Azure SQL DB PaaS offering without making changes to their database.

11. At the bottom right-hand corner of the page, select **Upload to Azure Migrate**. Then, when prompted to select the correct **Azure Environment**, select **Azure** instead of the other sovereign clouds. Select **Connect**.

12. Log into your Azure account.

13. In DMA, select the lab subscription and the Azure Migrate Project you created in the previous task. Feel free to ignore any errors, so long as you can select the correct Azure subscription and Azure Migrate Project. Then, select **Upload**.

    ![This image highlights the correct Azure subscription, Azure Migrate Project (wwi-sql-migrate-SUFFIX), and the Upload button in DMA.](./media/dma-subscription-and-migrate-project.png "Azure subscription and Azure Migrate Project selected in DMA")

14. Navigate to Azure Migrate, as explained in the previous Task. Select **Assess and migrate databases** again.

15. In the **Assessment tools** box, Azure should indicate that you assessed one database for an Azure migration. Note that you may need to select **Refresh** in the upper left-hand corner of the page to see the intended results.

    ![This image highlights the Assessed databases count in the Assessment tools section of the wwi-sql-migrate-SUFFIX project.](./media/azure-migrate-assessment-results-uploaded.png "Assessed databases count")

    >**Note**: If you still cannot see the uploaded assessment results after  selecting **Refresh**, ensure that the correct project (`wwi-sql-migrate-SUFFIX`) is selected at the upper right-hand corner of the page.
    >
    > ![This image demonstrates that the correct Azure Migrate project has been selected in the Azure Portal.](./media/correct-azure-migrate-project.png "Correct wwi-sql-migrate-SUFFIX Azure Migrate project")

16. Select **Assessed databases**. Observe the `WideWorldImporters` database. Verify that the **Target in Azure** is **Azure SQL Database** and that there is one breaking change.

17. Return to DMA. **Cancel** this project by going **back** to the home page.

    ![Cancel migration by going back to home page.](media/dma-cancel-project-migration.png "Cancel project migration")

### Task 4: Assess migration to Azure SQL Managed Instance

With one PaaS offering ruled out due to feature parity, perform a second DMA assessment against Azure SQL Managed Instance (SQL MI). The assessment provides a report about any feature parity and compatibility issues between the on-premises database and the SQL MI service.

1. To get started, select **+** on the left-hand menu in DMA to create another project.

   ![The new project icon is highlighted in DMA.](media/dma-new.png "New DMA project")

2. In the New project pane, set the following:

   - **Project name**: Enter `ToSqlMi`
   - **Target server type**: Select **Azure SQL Database Managed Instance**.

3. Select **Create**.

   ![The new project settings for doing a SQL Server to Azure SQL Managed Instance migration assessment are entered into the dialog.](media/dma-new-project-to-sql-mi.png "New project settings")

4. On the **Options** screen, ensure that **Check database compatibility** and **Check feature parity** are checked. Then, select **Next**.

   ![Check database compatibility and check feature parity are checked on the Options screen.](media/dma-options.png "DMA options")

5. On the **Sources** screen, enter the following into the **Connect to a server** dialog that appears on the right-hand side:

   - **Server name**: Select **SQLSERVER2008**.
   - **Authentication type**: Select **SQL Server Authentication**.
   - **Username**: Enter `WorkshopUser`
   - **Password**: Enter `Password.1234567890`
   - **Encrypt connection**: Check this box.
   - **Trust server certificate**: Check this box.

   ![In the Connect to a server dialog, the values specified above are entered.](media/dma-connect-to-a-server.png "Connect to a server")

6. Select **Connect**.

7. On the **Add sources** dialog that appears next, check the box for **WideWorldImporters** and select **Add**.

   ![The WideWorldImporters box is checked on the Add sources dialog.](media/dma-add-sources.png "Add sources")

8. Select **Start Assessment**.

   ![Start assessment](media/dma-start-assessment-to-azure-sql-db.png "Start assessment")

9. Review the **SQL Server feature parity** issues options of the migration assessment to determine the possibility of migrating to Azure SQL Managed Instance.

   ![For a target platform of Azure SQL Managed Instance, no issues are listed.](media/dma-feature-parity-sql-mi.png "Database feature parity")

10. Review the **Compatibility issues** options of the migration assessment to determine the possibility of migrating to Azure SQL Managed Instance.

    ![For a target platform of Azure SQL Managed Instance, there are no compatibility issues.](media/dma-compatibility-issues-sql-mi.png "Compatibility issues")

11. Repeat steps 11-13 from the previous Task to upload the assessment results to Azure Migrate.

12. Complete steps 14-15 of the previous Task to access the `wwi-sql-migrate-SUFFIX` project in Azure Migrate. This time, when you select **Assessed databases**, note that the **Target in Azure** is **Azure SQL Database Managed Instance** and that the **Breaking changes count** is 0.

The database, including the Service Broker feature, can be migrated as is, providing an opportunity for WWI to have a fully managed PaaS database running in Azure. Previously, their only option for migrating a database using features incompatible with Azure SQL Database, such as Service Broker, was to deploy the database to a virtual machine running in Azure (IaaS) or modify the database and associated applications to remove the use of the unsupported features. The introduction of Azure SQL MI, however, provides the ability to migrate databases into a managed Azure SQL database service with _near 100% compatibility_, including the features that prevented them from using Azure SQL Database.

You can close **Data Migration Assistant** by double-clicking the program icon. Also, **confirm** you are **not saving projects**, as you have another migration process in mind right now.

   ![Close data migration assistant.](media/dma-close-data-migration-assistant.png "Close data migration assistant")

## Exercise 2: Migrate the database to SQL MI

Duration: 60 minutes

In this exercise, you use the [Azure Database Migration Service](https://azure.microsoft.com/services/database-migration/) (DMS) to migrate the `WideWorldImporters` database from an on-premises SQL Server 2008 R2 database into Azure SQL Managed Instance (SQL MI). WWI mentioned the importance of their gamer information web application in driving revenue, so for this migration, the online migration option is used to minimize downtime. Targeting the [Business Critical service tier](https://docs.microsoft.com/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview#managed-instance-service-tiers) allows WWI to meet its customer's high-availability requirements.

> The Business Critical service tier is designed for business applications with the highest performance and high availability (HA) requirements. To learn more, read the [Managed Instance service tiers documentation](https://docs.microsoft.com/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview#service-tiers).

### Task 1: Create an SMB network share on the SqlServer2008 VM

In this task, you create a new SMB network share on the SqlServer2008 VM. DMS uses this shared folder for retrieving backups of the `WideWorldImporters` database during the database migration process.

1. On the SqlServer2008 VM, open **Windows Explorer** by selecting its icon on the Windows Taskbar.

   ![The Windows Explorer icon is highlighted in the Windows Taskbar.](media/windows-task-bar.png "Windows Taskbar")

2. In the Windows Explorer window, expand **Computer** in the tree view, select **Windows (C:)**, and then select **New folder** in the top menu.

   ![In Windows Explorer, Windows (C:) is selected under Computer in the left-hand tree view, and New folder is highlighted in the top menu.](media/windows-explorer-new-folder.png "Windows Explorer")

3. Name the new folder **dms-backups**. Then, right-click the folder and select **Share with** and **Specific people** in the context menu.

   ![In Windows Explorer, the context menu for the dms-backups folder is displayed, with Share with and Specific people highlighted.](media/windows-explorer-folder-share-with.png "Windows Explorer")

4. In the File Sharing dialog, ensure the **sqlmiuser** is listed with a **Read/Write** permission level and then select **Share**.

   ![In the File Sharing dialog, the sqlmiuser is highlighted and assigned a permission level of Read/Write.](media/file-sharing.png "File Sharing")

5. In the **Network discovery and file sharing** dialog, select the default value of **No, make the network that I am connected to a private network**.

   ![In the Network discovery and file sharing dialog, No, make the network that I am connected to a private network is highlighted.](media/network-discovery-and-file-sharing.png "Network discovery and file sharing")

6. Back on the File Sharing dialog, note the shared folder's path, `\\SQLSERVER2008\dms-backups`, and select **Done** to complete the sharing process.

   ![The Done button is highlighted on the File Sharing dialog.](media/file-sharing-done.png "File Sharing")

### Task 2: Change MSSQLSERVER service to run under the sqlmiuser account

In this task, you use the SQL Server Configuration Manager to update the service account used by the SQL Server (MSSQLSERVER) service to the `sqlmiuser` account. Changing the account used for this service ensures it has the appropriate permissions to write backups to the shared folder.

1. On your SqlServer2008 VM, select the **Start menu**, enter **sql configuration** into the search bar, and then select **SQL Server Configuration Manager** from the search results.

   ![In the Windows Start menu, "sql configuration" is entered into the search box, and SQL Server Configuration Manager is highlighted in the search results.](media/windows-start-sql-configuration-manager.png "Windows search")

   > **Note**: Be sure to choose **SQL Server Configuration Manager**, and not **SQL Server 2017 Configuration Manager**, which does not work for the installed SQL Server 2008 R2 database.

2. In the SQL Server Configuration Manager dialog, select **SQL Server Services** from the tree view on the left, then right-click **SQL Server (MSSQLSERVER)** in the list of services and select **Properties** from the context menu.

   ![SQL Server Services is selected and highlighted in the tree view of the SQL Server Configuration Manager. In the Services pane, SQL Server (MSSQLSERVER) is selected and highlighted. Properties is highlighted in the context menu.](media/sql-server-configuration-manager-services.png "SQL Server Configuration Manager")

3. In the SQL Server (MSSQLSERVER) Properties dialog, select **This account** under Log on as, and enter the following:

   - **Account name**: `sqlmiuser`
   - **Password**: Use the password used in the ARM template deployment (the default is `Password.1234567890`) and the same value in the **Confirm password** field

4. Select **OK**.

   ![In the SQL Server (MSSQLSERVER) Properties dialog, This account is selected under Log on as, and the sqlmiuser account name and password are entered.](media/sql-server-service-properties.png "SQL Server (MSSQLSERVER) Properties")

5. Select **Yes** in the Confirm Account Change dialog.

   ![The Yes button is highlighted in the Confirm Account Change dialog.](media/confirm-account-change.png "Confirm Account Change")

6. Observe the **Log On As** value for the SQL Server (MSSQLSERVER) service changed to `./sqlmiuser`.

   ![In the list of SQL Server Services, the SQL Server (MSSQLSERVER) service is highlighted.](media/sql-server-service.png "SQL Server Services")

7. **Close** the SQL Server Configuration Manager.

### Task 3: Create a backup of the WideWorldImporters database

To perform online data migrations, DMS looks for database and transaction log backups in the shared SMB backup folder on the source database server. In this task, you create a backup of the `WideWorldImporters` database using SSMS and write it to the `\\SQLSERVER2008\dms-backups` SMB network share you made in a previous task. The backup file needs to include a checksum, so you add that during the backup steps.

1. On the SqlServer2008 VM, open **Microsoft SQL Server Management Studio 17** by entering **microsoft sql** into the search bar in the Windows Start menu.

   ![SQL Server is entered into the Windows Start menu search box, and Microsoft SQL Server Management Studio 17 is highlighted in the search results.](media/start-menu-ssms-17.png "Windows start menu search")

2. In the SSMS **Connect to Server** dialog, enter **SQLSERVER2008** into the Server name box, ensure **Windows Authentication** is selected, and then select **Connect**.

   ![The SQL Server Connect to Search dialog is displayed, with SQLSERVER2008 entered into the Server name and Windows Authentication selected.](media/sql-server-connect-to-server.png "Connect to Server")

3. Once connected, expand **Databases** under SQLSERVER2008 in the Object Explorer, and then right-click the **WideWorldImporters** database. In the context menu, select **Tasks** and then **Back Up**.

   ![In the SSMS Object Explorer, the context menu for the WideWorldImporters database is displayed, with Tasks and Back Up... highlighted.](media/ssms-backup.png "SSMS Backup")

4. In the Back Up Database dialog, you should see `D:\WideWorldImporters.bak` listed in the Destinations box. This device is no longer needed, so select it and then select **Remove**.

   ![In the General tab of the Back Up Database dialog, C:\WideWorldImporters.bak is selected, and the Remove button is highlighted under destinations.](media/ssms-back-up-database-general-remove.png)

5. Next, select **Add** to add the SMB network share as a backup destination.

   ![In the General tab of the Back Up Database dialog, the Add button is highlighted under destinations.](media/ssms-back-up-database-general.png "Back Up Database")

6. In the Select Backup Destination dialog, select the Browse (`...`) button.

   ![The Browse button is highlighted in the Select Backup Destination dialog.](media/ssms-select-backup-destination.png "Select Backup Destination")

7. In the Location Database Files dialog, select the `C:\dms-backups` folder, enter `WideWorldImporters.bak` into the File name field, and then select **OK**.

   ![In the Select the file pane, the C:\dms-backups folder is selected and highlighted, and WideWorldImporters.bak is entered into the File name field.](media/ssms-locate-database-files.png "Location Database Files")

8. Select **OK** to close the Select Backup Destination dialog.

   ![The OK button is highlighted on the Select Backup Destination dialog and C:\dms-backups\WideWorldImporters.bak is entered in the File name textbox.](media/ssms-backup-destination.png "Backup Destination")

9. In the Back Up Database dialog, select **Media Options** in the Select a page pane, and then set the following:

   - Select **Back up to the existing media set** and then select **Overwrite all existing backup sets**.
   - Under Reliability, check the box for **Perform checksum before writing to media**. A checksum is required by DMS when using the backup to restore the database to SQL MI.

   ![In the Back Up Database dialog, the Media Options page is selected, and Overwrite all existing backup sets and Perform checksum before writing to media are selected and highlighted.](media/ssms-back-up-database-media-options.png "Back Up Database")

10. Select **OK** to perform the backup.

11. You will receive a message when the backup is complete. Select **OK**.

    ![Screenshot of the dialog confirming the database backup was completed successfully.](media/ssms-backup-complete.png "Backup complete")

As backup is done, you can close both **popup** and **management studio** windows.

### Task 4: Retrieve SQL MI and SQL Server 2008 VM connection information

In this task, you use the Azure Cloud shell to retrieve the information necessary to connect to your SqlServer2008 VM from DMS.

1. From any station, connect to [Azure portal](https://portal.azure.com), select the Azure Cloud Shell icon from the top menu.

   ![The Azure Cloud Shell icon is highlighted in the Azure portal's top menu.](media/cloud-shell-icon.png "Azure Cloud Shell")

2. In the Cloud Shell window that opens at the bottom of your browser window, select **PowerShell**.

   ![In the Welcome to Azure Cloud Shell window, PowerShell is highlighted.](media/cloud-shell-select-powershell.png "Azure Cloud Shell")

3. If prompted about not having a storage account mounted, select the subscription you are using for this hands-on lab and select **Create storage**.

   ![In the You have no storage mounted dialog, a subscription has been selected, and the Create Storage button is highlighted.](media/cloud-shell-create-storage.png "Azure Cloud Shell")

   > **Note**: If the creation fails, you may need to select **Show advanced settings** and specify the subscription, region, and resource group for the new storage account.

4. After a moment, a message is displayed that you have successfully requested a Cloud Shell, and you are presented with a PS Azure prompt.

   ![In the Azure Cloud Shell dialog, a message is displayed that requesting a Cloud Shell succeeded, and the PS Azure prompt is displayed.](media/cloud-shell-ps-azure-prompt.png "Azure Cloud Shell")

5. At the prompt, retrieve the public IP address of the SqlSerer2008 VM. This IP address will be used to connect to the database on that server. Enter the following PowerShell command, **replacing `<your-resource-group-name>`** in the resource group name variable with the name of your resource group:

   ```powershell
   $resourceGroup = "<your-resource-group-name>"
   az vm list-ip-addresses -g $resourceGroup -n SqlServer2008 --output table
   ```

   > **Note**: If you have multiple Azure subscriptions, and the account you are using for this hands-on lab is not your default account, you may need to run `az account list --output table` at the Azure Cloud Shell prompt to output a list of your subscriptions, then copy the Subscription Id of the account you are using for this lab and then run `az account set --subscription <your-subscription-id>` to set the appropriate account for the Azure CLI commands.

6. Within the output, locate and copy the value of the `ipAddress` property below the `PublicIPAddresses` field. Paste the value into a text editor, such as **Notepad.exe** or **VSCode**, for later reference.

   ![The output from the az vm list-ip-addresses command is displayed in the Cloud Shell, and the public IP address for the SqlServer2008 VM is highlighted.](media/cloud-shell-az-vm-list-ip-addresses.png "Azure Cloud Shell")

7. Leave the Azure Cloud Shell open for the next task.

### Task 5: Create a service principal

In this task, use the Azure Cloud Shell to create an Azure Active Directory (Azure AD) application and service principal (SP) that will provide DMS access to Azure SQL MI. You will grant the SP permissions to the hands-on-lab-SUFFIX resource group and your subscription.

> **Important**: You must have sufficient rights within your Azure AD tenant to create an Azure Active Directory application and service principal and assign roles on your subscription to complete this task.

1. Next, at the Cloud Shell prompt, issue a command to create a service principal named **wide-world-importers** and assign it contributor permissions to your **hands-on-lab-SUFFIX** resource group.

2. First, you need to retrieve your subscription ID. Enter the following at the Cloud Shell prompt:

   ```powershell
   az account list --output table
   ```

3. In the output table, locate the subscription you are using for this hands-on lab. Copy the SubscriptionId value and use it to replace `<your-subscription-id>` in the command below. Run the completed command at the CLI command prompt.

   ```powershell
   $subscriptionId = "<your-subscription-id>"
   ```

4. Next, enter the following `az ad sp create-for-rbac` command at the Cloud Shell prompt and then press `Enter` to run the command.

   ```powershell
   az ad sp create-for-rbac -n "https://wide-world-importers" --role contributor --scopes subscriptions/$subscriptionId/resourceGroups/$resourceGroup
   ```

5. Copy the output from the command into a text editor, as you need the `appId` and `password` in the next task. The output should be similar to:

   ```json
   {
     "appId": "aeab3b83-9080-426c-94a3-4828db8532e9",
     "displayName": "wide-world-importers",
     "name": "https://wide-world-importers",
     "password": "hd_42~OwuFk.mp1BQ8l6nKkzOLzg5vrQpC",
     "tenant": "d280491c-b27a-XXXX-XXXX-XXXXXXXXXXXX"
   }
   ```

6. To verify the role assignment, select **Access control (IAM)** from the left-hand menu of the **hands-on-lab-SUFFIX** resource group blade, and then select the **Role assignments** tab and locate **wide-world-importers** under the `Contributor` role.

   ![The Role assignments tab is displayed, with wide-world-importers highlighted under Contributor in the list.](media/rg-hands-on-lab-role-assignments.png "Role assignments")

7. Next, issue another command to grant the `Contributor` role at the subscription level to the newly created service principal. At the Cloud Shell prompt, run the following command:

   ```powershell
   az role assignment create --assignee https://wide-world-importers --role contributor
   ```

### Task 6: Create and run an online data migration project

In this task, you create a new online data migration project in DMS for the `WideWorldImporters` database.

1. In the [Azure portal](https://portal.azure.com), navigate to the Azure Database Migration Service by selecting **Resource groups** from the left-hand navigation menu, the **hands-on-lab-SUFFIX** resource group, and the **wwi-dms** Azure Database Migration Service from the list of resources.

   ![The wwi-dms Azure Database Migration Service is highlighted in the list of resources in the hands-on-lab-SUFFIX resource group.](media/resource-group-dms-resource.png "Resources")

2. On the Azure Database Migration Service blade, select **+New Migration Project**.

   ![On the Azure Database Migration Service blade, +New Migration Project is highlighted in the toolbar.](media/dms-add-new-migration-project.png "Azure Database Migration Service New Project")

   >**Note**: If you are completing this lab over multiple days, you will need to start the DMS Service before creating a migration project.

3. On the New migration project blade, enter the following:

   - **Project name**: Enter `OnPremToSqlMi`
   - **Source server type**: Select **SQL Server**.
   - **Target server type**: Select **Azure SQL Database Managed Instance**.
   - **Choose type of activity**: Select **Online data migration** and select **Save**.

4. Select **Create and run activity**.

   ![The New migration project blade is displayed, with the values specified above entered into the appropriate fields.](media/dms-new-migration-project-blade.png "New migration project")

5. On the Migration Wizard **Select source** tab, enter the following:

   - **Source SQL Server instance name**: Enter the IP address of your SqlServer2008 VM that you copied into a text editor in the previous task. For example, `104.40.208.46`.
   - **Authentication type**: Select `SQL Authentication`.
   - **Username**: Enter `WorkshopUser`
   - **Password**: Enter `Password.1234567890`
   - **Connection properties**: Check both Encrypt connection and Trust server certificate.

6. Select **Next : Select target**.

   ![The Migration Wizard Select source tab is displayed, with the values specified above entered into the appropriate fields.](media/dms-migration-wizard-select-source.png "Migration Wizard Select source")

7. On the Migration Wizard **Select target** tab, enter the following:

   - **Application ID**: Enter the `appId` value from the output of the `az ad sp create-for-rbac' command you executed in the last task.
   - **Key**: Enter the `password` value from the output of the `az ad sp create-for-rbac' command you executed in the last task.
   - **Target Azure SQL Managed Instance**: Select the sqlmi-UNIQUEID instance.
   - **SQL Username**: Enter `sqlmiuser`
   - **Password**: Enter the password used in the ARM template deployment (the default is `Password.1234567890`)

8. Select **Next : Select databases**.

   ![The Migration Wizard Select target tab is displayed, with the values specified above entered into the appropriate fields.](media/dms-migration-wizard-select-target.png "Migration Wizard Select target")

9. On the Migration Wizard **Select databases** tab, select `WideWorldImporters`.

10. Select **Next : Configure migration settings**.

    ![The Migration Wizard Select databases tab is displayed, with the WideWorldImporters database selected.](media/dms-migration-wizard-select-databases.png "Migration Wizard Select databases")

11. On the Migration Wizard **Configure migration settings** tab, enter the following configuration:

    - **Network share location**: Populate this field with the path to the SMB network share you created previously by entering `\\SQLSERVER2008\dms-backups`.
    - **Windows User Azure Database Migration Service impersonates to upload files to Azure Storage**: Enter `SQLSERVER2008\sqlmiuser.`
    - **Password**: Enter `Password.1234567890`
    - **Storage account**: Select the **sqlmistoreUNIQUEID** storage account.

12. Select **Next : Summary**.

    ![The Migration Wizard Configure migration settings tab is displayed, with the values specified above entered into the appropriate fields.](media/dms-migration-wizard-configure-migration-settings.png "Migration Wizard Configure migration settings")

13. On the Migration Wizard **Summary** tab, enter `WwiMigration` as the **Activity name**.

14. Select **Start migration**.

    ![The Migration Wizard summary tab is displayed, WwiMigration is entered into the name field, and Validate my database(s) is selected in the Choose validation option blade, with all three validation options selected.](media/dms-migration-wizard-migration-summary.png "Migration Wizard Summary")

15. Monitor the migration on the status screen that appears. You can select the refresh icon in the toolbar to retrieve the latest status. Continue selecting **Refresh** every 5-10 seconds until you see the status change to **Log shipping in progress**. When that status appears, move on to the next task.

    ![In the migration monitoring window, a status of Log shipping in progress is highlighted.](media/dms-migration-wizard-status-log-files-uploading.png "Migration status")

You can leave the Azure Portal browser window open and come back to check that migration is complete. This is a perfect time for a break.

### Task 7: Perform migration cutover

Since you performed an "online data migration," the migration wizard continuously monitors the SMB network share for newly added log backup files. Online migrations enable any updates on the source database to be captured until you initiate the cutover to the SQL MI database. In this task, you add a record to one of the database tables, backup the logs, and complete the migration of the `WideWorldImporters` database by cutting over to the SQL MI database.

1. In the Azure portal's migration status window, select **WideWorldImporters** under Database name to view further details about the database migration.

   ![The WideWorldImporters database name is highlighted in the migration status window.](media/dms-migration-wizard-database-name.png "Migration status")

2. On the WideWorldImporters screen, note the status of **Restored** for the `WideWorldImporters.bak` file.

   ![On the WideWorldImporters blade, a status of Restored is highlighted next to the WideWorldImporters.bak file in the list of active backup files.](media/dms-migration-wizard-database-restored.png "Migration Wizard")

3. To demonstrate log shipping and how transactions made on the source database during the migration process are added to the target SQL MI database, you will add a record to one of the database tables.

4. Return to SSMS on your SqlServer2008 VM and select **New Query** from the toolbar.

   ![The New Query button is highlighted in the SSMS toolbar.](media/ssms-new-query.png "SSMS Toolbar")

5. Paste the following SQL script, which inserts a record into the `Game` table, into the new query window:

   ```sql
   USE WideWorldImporters;
   GO

   INSERT [dbo].[Game] (Title, Description, Rating, IsOnlineMultiplayer)
   VALUES ('Space Adventure', 'Explore the universe with our newest online multiplayer gaming experience. Build custom  rocket ships, and take off for the stars in an infinite open-world adventure.', 'T', 1)
   ```

6. Execute the query by selecting **Execute** in the SSMS toolbar.

   ![The Execute button is highlighted in the SSMS toolbar.](media/ssms-execute.png "SSMS Toolbar")

7. After adding the new record to the `Games` table, back up the transaction logs. DMS detects any new backups and ships them to the migration service. Select **New Query** again in the toolbar, and type the commands in the image below.

   ![This image shows the commands executed in the SQL Server system database to create a transaction log backup.](./media/system-database-create-transaction-log-backup.png "Creating a transaction log backup")

8. Execute the query by selecting **Execute** in the SSMS toolbar.

9. Return to the migration status page in the Azure portal. On the WideWorldImporters screen, select **Refresh**, and you should see the **WideWorldImportersLog.trn** file appear with a status of **Queued**.

   ![On the WideWorldImporters blade, the Refresh button is highlighted. A status of Uploaded is highlighted next to the WideWorldImportersLog.trn file in the list of active backup files.](media/dms-migration-wizard-transaction-log-queued.png "Migration wizard")

   > **Note**: If you don't see it in the transaction logs entry, continue selecting refresh every 10-15 seconds until it appears.

10. Continue selecting **Refresh**, and you should see the **WideWorldImportersLog.trn** status change to **Uploaded**.

    ![A status of Uploaded is highlighted next to the WideWorldImportersLog.trn file in the list of active backup files.](media/dms-migration-wizard-transaction-log-uploaded.png "Migration Wizard")

11. After the transaction logs are uploaded, they are restored to the database. Once again, continue selecting **Refresh** every 10-15 seconds until you see the status change to **Restored**, which can take a minute or two.

    ![A status of Restored is highlighted next to the WideWorldImportersLog.trn file in the list of active backup files.](media/dms-migration-wizard-transaction-log-restored.png "Migration Wizard")

12. After verifying the transaction log status of **Restored**, select **Start Cutover**.

    ![The Start Cutover button is displayed.](media/dms-migration-wizard-start-cutover.png "DMS Migration Wizard")

13. On the Complete cutover dialog, verify pending log backups is `0`, select **Confirm**, and then select **Apply**.

    ![In the Complete cutover dialog, 0 is highlighted next to Pending log backups, and the Confirm checkbox is checked.](media/dms-migration-wizard-complete-cutover-apply.png "Migration Wizard")

14. A progress bar below the Apply button in the Complete cutover dialog provides updates on the cutover status. When the migration finishes, the status changes to **Completed**.

    ![A status of Completed is displayed in the Complete cutover dialog.](media/dms-migration-wizard-complete-cutover-completed.png "Migration Wizard")

    > **Note**: If the progress bar has not moved after a few minutes, you can proceed to the next step and monitor the cutover progress on the WwiMigration blade by selecting refresh.

    > **Note**: To meet the Business Critical tier's high availability requirements, Azure creates a four node cluster based on *Always On* availability groups. This affects the cutover time.

15. To return to the WwiMigration blade, close the Complete cutover dialog by selecting the "X" in the upper right corner of the dialog, and do the same thing for the WideWorldImporters blade. Select **Refresh**, and you should see a status of **Completed** from the WideWorldImporters database.

    ![On the Migration job blade, the status of Completed is highlighted.](media/dms-migration-wizard-status-complete.png "Migration with Completed status")

16. You have successfully migrated the `WideWorldImporters` database to Azure SQL Managed Instance.

### Task 8: Verify database and transaction log migration

In this task, you connect to the SQL MI database using SSMS and quickly verify the migration.

1. First, use the Azure Cloud Shell to retrieve the fully qualified domain name of your SQL MI database. In the [Azure portal](https://portal.azure.com), select the Azure Cloud Shell icon from the top menu.

   ![The Azure Cloud Shell icon is highlighted in the Azure portal's top menu.](media/cloud-shell-icon.png "Azure Cloud Shell")

2. In the Cloud Shell window that opens at the bottom of your browser window, select **PowerShell**.

   ![In the Welcome to Azure Cloud Shell window, PowerShell is highlighted.](media/cloud-shell-select-powershell.png "Azure Cloud Shell")

3. After a moment, a message is displayed that you have successfully requested a Cloud Shell and be presented with a PS Azure prompt.

   ![In the Azure Cloud Shell dialog, a message is displayed that requesting a Cloud Shell succeeded, and the PS Azure prompt is displayed.](media/cloud-shell-ps-azure-prompt.png "Azure Cloud Shell")

4. At the prompt, retrieve information about SQL MI in the hands-on-lab-SUFFIX resource group by entering the following PowerShell command, **replacing `<your-resource-group-name>`** in the resource group name variable with the name of your resource group:

   ```powershell
   $resourceGroup = "<your-resource-group-name>"
   az sql mi list --resource-group $resourceGroup
   ```

   > **Note**: If you have multiple Azure subscriptions, and the account you are using for this hands-on lab is not your default account, you may need to run `az account list --output table` at the Azure Cloud Shell prompt to output a list of your subscriptions. Copy the Subscription Id of the account you are using for this lab and then run `az account set --subscription <your-subscription-id>` to set the appropriate account for the Azure CLI commands.

5. Within the above command's output, locate and copy the value of the `fullyQualifiedDomainName` property. Paste the value into a text editor, such as Notepad.exe, for reference below.

   ![The output from the az sql mi list command is displayed in the Cloud Shell, and the fullyQualifiedDomainName property and value are highlighted.](media/cloud-shell-az-sql-mi-list-output.png "Azure Cloud Shell")

6. Return to SSMS on your SqlServer2008 VM, and then select **Connect** and **Database Engine** from the Object Explorer menu.

   ![In the SSMS Object Explorer, Connect is highlighted in the menu, and Database Engine is highlighted in the Connect context menu.](media/ssms-object-explorer-connect.png "SSMS Connect")

7. In the Connect to Server dialog, enter the following:

   - **Server name**: Enter the fully qualified domain name of your SQL managed instance, which you copied from the Azure Cloud Shell in the previous steps.
   - **Authentication**: Select **SQL Server Authentication**.
   - **Login**: Enter `sqlmiuser`
   - **Password**: Use the password provided in the ARM template deployment (default is `Password.1234567890`)

8. Select **Connect**.

   ![The SQL managed instance details specified above are entered into the Connect to Server dialog.](media/ssms-connect-to-server-sql-mi.png "Connect to Server")

9. The SQL MI connection appears below the SQLSERVER2008 connection. Expand Databases the SQL MI connection and select the `WideWorldImporters` database.

10. With the `WideWorldImporters` database selected, select **New Query** on the SSMS toolbar to open a new query window.

   ![In the SSMS Object Explorer, the SQL MI connection is expanded, and the WideWorldImporters database is highlighted and selected.](media/ssms-sql-mi-database.png "SSMS Object Explorer")

11. In the new query window, enter the following SQL script:

    ```sql
    USE WideWorldImporters;
    GO

    SELECT * FROM Game
    ```

12. Select **Execute** on the SSMS toolbar to run the query. Observe the records contained within the `Game` table, including the new `Space Adventure` game you added after initiating the migration process.

    ![In the new query window, the query above has been entered, and in the results pane, the new Space Adventure game is highlighted.](media/ssms-query-game-table.png "SSMS Query")

13. You are done using the SqlServer2008 VM. **Close** any open windows and **log off** the VM.

The JumpBox VM is used for the remaining tasks of this hands-on lab.

## Exercise 3: Update the web application to use the new SQL MI database

Duration: 30 minutes

With the `WideWorldImporters` database now running on SQL MI in Azure, the next step is to make the required modifications to the WideWorldImporters gamer information web application.

> **Note**: Azure SQL Managed Instance has a private IP address in a dedicated VNet, so to connect an application, you must configure access to the VNet where Managed Instance is deployed. To learn more, read [Connect your application to Azure SQL Managed Instance](https://docs.microsoft.com/azure/azure-sql/managed-instance/connect-application-instance).

### Task 1: Assess the Application with the Data Access Migration Toolkit (Optional)

In this Task, you will install and utilize the Data Access Migration Toolkit Visual Studio Code extension to assess the app to prevent it from hindering a migration from on-premises SQL Server.

1. Launch Visual Studio Code from the start menu. It should already be installed with the Virtual Machine image, but if it is not, [download](https://code.visualstudio.com/Download) and install it.

2. Open the **Extensions** tab (1). Search for the **Data Access Migration Toolkit** (2). Select **Install** (3).

   ![This image shows how to navigate to the Extensions blade in Visual Studio Code and locate and install the Data Access Migration Toolkit.](./media/install-damt-vs-code.png "Installing Data Access Migration Toolkit extension")

3. At the upper left-hand corner of the page, select **File > Open Folder...**. Navigate to `C:\hands-on-lab\MCW-Migrating-SQL-databases-to-Azure-main\Hands-on lab\lab-files\WideWorldImporters.Web` in the dialog. Then, select **Select Folder**.

4. If you are asked to trust the authors of the files in the project folder, select **Yes, I trust the authors**.

5. Enter Ctrl+Shift+P to open the Visual Studio Code extension console. Then, query and select **Data Access: Analyze workspace**.

6. When asked to select a SQL dialect, select **SQL Server**.

   ![This image shows how to select the SQL Server dialect from the list of three dialects in the Visual Studio Code Extension Console.](./media/sql-server-dialect-damt.png "Selecting SQL Server dialect")

7. In the report, the Data Access Migration Toolkit identifies two connection string references (1) and a SQL Query that determines whether the referenced database supports read-write or read-only operations (for Exercise 7).

   ![This image highlights the connection strings (1) and SQL queries (2) determined by the Data Access Migration Toolkit Results summary section.](./media/damt-results-summary.png "Visualizing connection strings and SQL queries in the DAMT assessment")

Because the application utilizes an ORM, there are not many ad-hoc SQL queries that need to be verified for compatibility with the target Azure SQL Managed Instance.

### Task 2: Deploy the web app to Azure

In this task, you create an RDP connection to the JumpBox VM and then, using Visual Studio on the JumpBox, deploy the `WideWorldImporters` web application into the App Service in Azure.

1. In the [Azure portal](https://portal.azure.com), select **Resource groups** in the Azure navigation pane and select the **hands-on-lab-SUFFIX** resource group from the list.

   ![Resource groups is selected in the Azure navigation pane, and the "hands-on-lab-SUFFIX" resource group is highlighted.](./media/resource-groups.png "Resource groups list")

2. In the list of resources for your resource group, select the JumpBox VM.

   ![The list of resources in the hands-on-lab-SUFFIX resource group are displayed, and JumpBox is highlighted.](./media/resource-group-resources-jumpbox.png "JumpBox in resource group list")

3. On your JumpBox VM blade, select **Connect** and **RDP** from the top menu.

   ![The JumpBox VM blade is displayed, with the Connect button highlighted in the top menu.](./media/connect-vm-rdp.png "Connect to JumpBox VM")

4. On the Connect with RDP blade, select **Download RDP File**, then open the downloaded RDP file.

5. Select **Connect** on the Remote Desktop Connection dialog.

   ![In the Remote Desktop Connection Dialog Box, the Connect button is highlighted.](./media/remote-desktop-connection.png "Remote Desktop Connection dialog")

6. Enter the following credentials when prompted, and then select **OK**:

   - **Username**: `sqlmiuser`
   - **Password**: Use the password provided during the ARM template deployment (the default is `Password.1234567890`)

   ![The credentials specified above are entered into the Enter your credentials dialog.](media/rdc-credentials.png "Enter your credentials")

7. Select **Yes** to connect if prompted the remote computer's identity cannot be verified.

   ![In the Remote Desktop Connection dialog box, a warning states the remote computer's identity cannot be verified and asks if you want to continue anyway. At the bottom, the Yes button is circled.](./media/remote-desktop-connection-identity-verification-jumpbox.png "Remote Desktop Connection dialog")

8. Once logged in, open File Explorer by selecting it in the Windows start bar.

   ![The File Explorer icon is highlighted in the Windows start bar.](media/windows-2019-start-bar-file-explorer.png "Windows start bar")

9. In the File Explorer dialog, navigate to the `C:\hands-on-lab` folder and then drill down to `Migrating-SQL-databases-to-Azure-main\Hands-on lab\lab-files`. In the `lab-files` folder, double-click `WideWorldImporters.sln` to open the solution in Visual Studio.

   ![WideWorldImporters.sln is highlighted in the folder at the aforementioned path.](media/windows-explorer-lab-files-web-solution.png "Windows Explorer")

10. If prompted about how you want to open the file, select **Visual Studio 2019**, and then select **OK**.

    ![In the Visual Studio version selector, Visual Studio 2019 is selected and highlighted.](media/visual-studio-version-selector.png "Visual Studio")

11. Select **Sign in** and enter your Azure account credentials when prompted.

    ![On the Visual Studio welcome screen, the Sign in button is highlighted.](media/visual-studio-sign-in.png "Visual Studio")

12. If you receive a security warning prompt, uncheck **Ask me for every project in this solution**, and then select **OK**.

    ![A Visual Studio security warning is displayed, and the Ask me for every project in this solution checkbox is unchecked and highlighted.](media/visual-studio-security-warning.png "Visual Studio")

13. Once logged into Visual Studio, right-click the `WideWorldImporters.Web` project in the Solution Explorer, and then select **Publish**.

    ![In the Solution Explorer, the context menu for the WideWorldImporters.Web project is displayed, and Publish is highlighted.](media/visual-studio-project-publish.png "Visual Studio")

14. On the **Publish** dialog, select **Azure** in the Target box, and select **Next**.

    ![In the Publish dialog, Azure is selected and highlighted in the Target box. The Next button is highlighted.](media/vs-publish-to-azure.png "Publish API App to Azure")

15. Next, in the **Specific target** box, select **Azure App Service (Windows)**.

    ![In the Publish dialog, Azure App Service (Windows) is selected and highlighted in the Specific Target box. The Next button is highlighted.](media/vs-publish-specific-target.png "Publish API App to Azure")

16. Finally, in the **App Service** box, select your subscription, expand the hands-on-lab-SUFFIX resource group, and select the `wwi-web-UNIQUEID` Web App.

17. Select **Finish**.

    ![In the Publish dialog, The wwi-web-UNIQUEID Web App is selected and highlighted under the hands-on-lab-SUFFIX resource group.](media/vs-publish-web-app-service.png "Publish API App to Azure")

18. Back on the Visual Studio Publish page for the `WideWorldImporters.Web` project, select **Publish** to start the process of publishing the ASP.NET Core web application to Azure App Service.

    ![The Publish button is highlighted on the Publish page in Visual Studio.](media/visual-studio-publish-web-app.png "Publish")

19. When the publish completes, you will see a message on the Visual Studio Output page the publish succeeded.

    ![The Publish Succeeded message is displayed in the Visual Studio Output pane.](media/visual-studio-output-publish-succeeded.png "Visual Studio")

20. If you select the link of the published web app from the Visual Studio output window, an error page is returned because the database connection strings have not been updated to point to the SQL MI database. You address this in the next task.

    ![An error screen is displayed because the database connection string has not been updated to point to SQL MI in the web app's configuration.](media/web-app-error-screen.png "Web App error")

### Task 3: Update App Service configuration

In this task, you update the WWI gamer info web application to connect to and utilize the SQL MI database.

1. In the [Azure portal](https://portal.azure.com), select **Resource groups** from the Azure services list.

   ![Resource groups is highlighted in the Azure services list.](media/azure-services-resource-groups.png "Azure services")

2. Select the hands-on-lab-SUFFIX resource group from the list.

   ![Resource groups is selected in the Azure navigation pane, and the "hands-on-lab-SUFFIX" resource group is highlighted.](./media/resource-groups.png "Resource groups list")

3. In the list of resources for your resource group, select the **hands-on-lab-SUFFIX** resource group, and then select the **wwi-web-UNIQUEID** App Service from the list of resources.

   ![The wwi-web-UNIQUEID App Service is highlighted in the list of resource group resources.](media/rg-app-service.png "Resource group")

4. On the App Service blade, select **Configuration** under Settings on the left-hand side.

   ![The Configuration item is selected under Settings.](media/app-service-configuration-menu.png "Configuration")

5. On the Configuration blade, locate the **Connection strings** section and then select the Pencil (Edit) icon to the right of the `WwiContext` connection string.

   ![In the Connection string section, the pencil icon is highlighted to the right of the WwiContext connection string.](media/app-service-configuration-connection-strings.png "Connection Strings")

6. The value of the connection string should look like this:

   ```sql
   Server=tcp:your-sqlmi-host-fqdn-value,1433;Database=WideWorldImporters;User ID=sqlmiuser;Password=Password.1234567890;Trusted_Connection=False;Encrypt=True;TrustServerCertificate=True;
   ```

7. In the Add/Edit connection string dialog, replace `your-sqlmi-host-fqdn-value` with the fully qualified domain name for your SQL MI that you copied to a text editor earlier from the Azure Cloud Shell.

   ![The your-sqlmi-host-fqdn-value string is highlighted in the connection string.](media/app-service-configuration-edit-conn-string.png "Edit Connection String")

8. The updated value should look similar to the following screenshot. Select **OK**.

   ![The updated connection string is displayed, with the fully qualified domain name of SQL MI highlighted within the string.](media/app-service-configuration-edit-conn-string-value.png "Connection string value")

9.  Repeat steps 3 - 7, this time for the `WwiReadOnlyContext` connection string.

10. Select **Save** at the top of the Configuration blade.

    ![The save button on the Configuration blade is highlighted.](media/app-service-configuration-save.png "Save")

11. When prompted that changes to application settings and connection strings will restart your application, select **Continue**.

    ![The prompt warning the application will be restarted is displayed, and the Continue button is highlighted.](media/app-service-restart.png "Restart prompt")

12. Select **Overview** to the left of the Configuration blade to return to the overview blade of your App Service.

    ![Overview is highlighted on the left-hand menu for App Service](media/app-service-overview-menu-item.png "Overview menu item")

13. At this point, selecting the **URL** for the App Service on the Overview blade still results in an error being return. The error occurs because SQL Managed Instance has a private IP address in its VNet. To connect an application, you need to configure access to the VNet where Managed Instance is deployed, which you handle in the next exercise.

    ![An error screen is displayed because the application cannot connect to SQL MI within its private virtual network.](media/web-app-error-screen.png "Web App error")

## Exercise 4: Integrate App Service with the virtual network

Duration: 15 minutes

In this exercise, you integrate the WWI App Service with the virtual network created during the Before the hands-on lab exercises. The ARM template created a Gateway subnet on the VNet, as well as a Virtual Network Gateway. Both resources are required to integrate App Service and connect to SQL MI.

The image below from the Microsoft documentation explains how worker virtual machines in Azure App Service can access resources on a virtual network subnet, such as SQL MI. 

![This image demonstrates how Point to Site VPN can be employed for Azure App Service to securely access resources in a Virtual Network.](./media/vnetint-how-gateway-works.png "VNet integration for Azure App Service")

### Task 1: Generate and export certificates for Point-to-Site

Point-to-Site connections use certificates to authenticate. Each client computer that connects to a VNet using Point-to-Site must have a client certificate installed. In this task, you will generate a client certificate from a self-signed root certificate.

1. Switch over to your JumpBox VM, right-click on the Windows 10 start menu, and select **Windows PowerShell (Admin) (2)** to open a new PowerShell session.

   ![Bottom left corner of the screen is highlighted. A context menu is open. Windows PowerShell (Admin) selection is highlighted.](media/new-powershell-session.png "Open new PowerShell session")

2. Run the code snippets below to create a self-signed root **(1)** and client **(2)** certificate.

   ![PowerShell window is presented. Self-signed root and client certificate creation commands are executed.](media/powershell-root-client-certificate-commands.png "Root and Client certificate creation commands")

   ```powershell
   $cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
   -Subject "CN=WWITTT" -KeyExportPolicy Exportable `
   -HashAlgorithm sha256 -KeyLength 2048 `
   -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign

   New-SelfSignedCertificate -Type Custom -DnsName WWITTTCLIENT -KeySpec Signature `
   -Subject "CN=WWITTTCLIENT" -KeyExportPolicy Exportable `
   -HashAlgorithm sha256 -KeyLength 2048 `
   -CertStoreLocation "Cert:\CurrentUser\My" `
   -Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")
   ```

3. Search for `Manage user certificates` **(1)** in the Start menu and launch the **Manage user certificates** control panel. Navigate to **Current User > Personal > Certificates** to find the two certificates **(3)** named WWITTT and WWITTTCLIENT. Right-click WWITT.

   ![Windows Search box is filled with "Manage user certificates". Manage user certificates result is selected.Current User > Personal > Certificates folder is shown. WWITTT and WWITTTCLIENT certificates are highlighted.](media/manager-user-certificates.png "WWITTT and WWITTTCLIENT certificates")

4. Right-click **WWITTT (1)** and select **All Tasks (2) > Export (3)**. Select **Next** on the following screen.

   ![WWITTT is selected. The right-click context menu is open. All Tasks submenu is open. The export command is highlighted.](media/root-certificate-export.png "Export WWITTT tasks")

5. Select **No, do not export the private key (1)** and select **Next (2)** to continue.

   ![No, do not export the private key selection is selected. The Next button is highlighted.](media/root-certificate-export-no-private-key.png "Export Private Key")

6. Pick **Base-64 encoded X.509 (1)** and select **Next (2)** to continue.

   ![Base-64 encoded X.509 is selected. The Next button is highlighted.](media/root-certificate-export-base-64.png "Export File Format")

7. Pick desktop for the file location and type `wwi-root.cer` **(1)** for the file name. Select **Next (2)** to continue.

   ![wwi-root.cer on the desktop is provided as a save location. The Next button is highlighted.](media/root-certificate-export-to-desktop.png "Specify File to Export")

8. Select **Finish** to close the dialog.

9. Find the **wwi-root.cert (1)** file on the desktop and right-click to open the context menu. Select **Open with... (2)**.

   ![wwi-root.cert context menu is open. Open with... command is highlighted.](media/root-certificate-open-with.png "WWI-root.cert context menu")

10. Pick **Notepad (1)** and select **OK (2)**.

    ![From file open dialog Notepad is selected. The OK button is highlighted.](media/root-certificate-open-with-notepad.png "Open Notepad")

11. Highlight the Public Key without the `-----BEGIN CERTIFICATE-----` and `-----END CERTIFICATE-----` parts. Copy the public key and paste the value into a text editor, such as Notepad.exe, for later reference.

    ![CERT file is open in notepad. Public Key is highlighted.](media/root-certificate-public-key-selection.png "CERT file in Notepad")

### Task 2: Set point-to-site addresses

In this task, you configure the client address pool. The address pool is a range of private IP addresses that you specify below. Clients that connect over a Point-to-Site VPN dynamically receive an IP address from this range. You use a private IP address range that does not overlap with the VNet.

1. Navigate to the **hands-on-lab-SUFFIX-vnet-gateway** Virtual network gateway in the [Azure portal](https://portal.azure.com) by selecting it from the list of resources in the hands-on-lab-SUFFIX resource group.

   ![The Virtual network gateway resource is highlighted in the list of resources.](media/resource-group-vnet-gateway.png "Resources")

2. On the virtual network gateway blade, select **Point-to-site configuration** under Settings in the left-hand menu, and then select **Configure now**.

   ![User VPN configuration is highlighted and selected in the left-hand menu. On the User VPN configuration blade, Configure now is highlighted.](media/virtual-network-gateway-configure-point-to-site.png "Virtual network gateway User VPN configuration")

3. On the **Point-to-site** configuration page, set the following configuration:

   - **Address pool (1)**: Add a private IP address range that you want to use. The address space must be in one of the following address blocks but should not overlap the address space used by the VNet.
     - `10.0.0.0/8` - This means an IP address range from 10.0.0.0 to 10.255.255.255
     - `172.16.0.0/12` - This means an IP address range from 172.16.0.0 to 172.31.255.255
     - `192.168.0.0/16` - This means an IP address range from 192.168.0.0 to 192.168.255.255
   - **Tunnel type (2)**: Select **SSTP (SSL)**.
   - **Authentication type (3)**: Choose **Azure certificate**.
   - **Root Certificate Name (4)**: `WWITTT`
   - **Public certificate data (5)**: Paste the Public Key you noted in the previous task.

4. Select **Save (6)** to validate and save the settings.

   ![The values specified above are entered into the Point-to-site configuration form.](media/virtual-network-gateway-point-to-site-configuration.png "Virtual network gateway")

5. It takes a few minutes for the save to finish. You can open **Notifications (1)** from the top bar in the portal and check progress **(2)** if needed.

   ![Portal notifications list is open. Saved virtual network gateway message is highlighted.](media/virtual-network-gateway-save-status.png "Portal notifications list")

### Task 3: Configure VNet integration with App Services

In this task, you add the networking configuration to your App Service to enable communication with resources in the VNet.

1. In the [Azure portal](https://portal.azure.com), select **Resource groups** from the left-hand menu, select the **hands-on-lab-SUFFIX** resource group and then select the **wwi-web-UNIQUEID** App Service from the list of resources.

   ![The wwi-web-UNIQUEID App Service is highlighted in the list of resource group resources.](media/rg-app-service.png "Resource group")

2. On the App Service blade, select **Networking** from the left-hand menu and then select **VNet integration**.

   ![On the App Service blade, Networking is selected in the left-hand menu, then VNet integration is highlighted.](media/app-service-networking.png "App Service")

3. Select **Add VNet** on the VNet Configuration blade.

   ![Add VNet is highlighted on the VNet Configuration blade.](media/app-service-vnet-configuration.png "App Service")

4. On the **Add VNet Integration** dialog, enter the following:

   - **Virtual Network**: Select the hands-on-lab-SUFFIX-vnet.
   - **Subnet**: Select Create New Subnet.
   - **Subnet Name**: Enter WebAppSubnet.
   - **Virtual Network Address Block**: Select the only option under this dropdown, 10.x.0.0/16.
   - **Subnet Address Block**: Enter a subnet with a /24 block, such as 10.x.3.0/24.

   ![The values specified above are entered into the Add VNet Integration dialog.](media/app-service-vnet-add-vnet-integration.png "Add VNet Integration configuration")

5. Within a few minutes, the VNet is added, and your App Service is restarted to apply the changes. Select **Refresh** to see the details. You should see the certificate status is Certificates in sync. **Note**: If the certificate status is not in sync, try hitting refresh, as it can take a moment for that status to be reflected.

   ![The details of the VNet Configuration are displayed. The Certificate Status, Certificates in sync, is highlighted.](media/app-service-vnet-details.png "App Service")

   > **Note**: If you receive a message adding the Virtual Network to Web App failed, select **Disconnect** on the VNet Configuration blade, and repeat steps 3 - 5 above.

### Task 4: Open the web application

In this task, you verify your web application now loads, and you can see the home page of the web app.

1. Select **Overview** in the left-hand menu of your App Service and select the **URL** of your App service to launch the website. This link opens the URL in a browser window.

   ![The App service URL is highlighted.](media/app-service-url.png "App service URL")

2. Verify that the website and data are loaded correctly. The page should look similar to the following:

   ![Screenshot of the WideWorldImporters Operations Web App.](media/wwi-web-app.png "WideWorldImporters Web")

   > **Note**: It can often take several minutes for the network configuration to be reflected in the web app. If you get an error screen, try selecting Refresh a few times in the browser window. If that does not work, try selecting **Restart** on the Azure Web App's toolbar.

You successfully connected your application to the new SQL MI database.

## Exercise 5: Improve database security posture with Data Discovery and Classification and Azure Defender for SQL

Duration: 30 minutes

In this exercise, you enable some of the advanced security features of SQL MI and explore some of the security benefits that come with running your database in Azure. [Azure Defender for SQL](https://docs.microsoft.com/azure/azure-sql/database/azure-defender-for-sql) provides advanced SQL security capabilities, including functionality for surfacing and mitigating potential database vulnerabilities and detecting anomalous activities that could indicate a threat to your database. Also, the [Data Discovery and Classification](https://docs.microsoft.com/azure/azure-sql/database/data-discovery-and-classification-overview) tool allows you to discover and classify sensitive data within the database.

### Task 1: Configure Data Discovery and Classification

In this task, you review the [Data Discovery and Classification](https://docs.microsoft.com/azure/azure-sql/database/data-discovery-and-classification-overview) feature of Azure SQL. Data Discovery & Classification introduces a new tool for discovering, classifying, labeling, and reporting sensitive data in your databases. It introduces a set of advanced services, forming a new SQL Information Protection paradigm aimed at protecting the data in your database, not just the database. Discovering and classifying your most sensitive data (e.g., business, financial, healthcare) can play a pivotal role in your organizational information protection stature.

1. On the WideWorldImporters Managed database blade, select the **Data Discovery & Classification** from the left-hand menu.

2. In the **Data Discovery & Classification** blade, select the info link with the message, **We have found 35 columns with classification recommendations**.

   ![The Data Discovery & Classification tile is displayed.](media/ads-data-discovery-and-classification-pane.png "Data Discovery & Classification Dashboard")

3. Look over the list of recommendations to get a better understanding of the types of data and classifications that can be assigned, based on the built-in classification settings. In the list of classification recommendations, select the recommendation for the **Sales - CreditCard - CardNumber** field.

   ![The CreditCard number recommendation is highlighted in the recommendations list.](media/ads-data-discovery-and-classification-recommendations-credit-card.png "Data Discovery & Classification")

4. Due to the risk of exposing credit card information, WWI would like a way to classify it as highly confidential, not just **Confidential**, as the recommendation suggests. To correct this, select **+ Add classification** at the top of the Data Discovery & Classification blade.

   ![The +Add classification button is highlighted in the toolbar.](media/ads-data-discovery-and-classification-add-classification-button.png "Data Discovery & Classification")

5. Quickly expand the **Sensitivity label** field and review the various built-in labels from which you can choose. You can also add custom labels, should you desire.

   ![The list of built-in Sensitivity labels is displayed.](media/ads-data-discovery-and-classification-sensitivity-labels.png "Data Discovery & Classification")

6. In the Add classification dialog, enter the following:

   - **Schema name**: Select **Sales**.
   - **Table name**: Select **CreditCard**.
   - **Column name**: Select **CardNumber (nvarchar)**.
   - **Information type**: Select **Credit Card**.
   - **Sensitivity level**: Select **Highly Confidential**.

7. Select **Add classification**.

   ![The values specified above are entered into the Add classification dialog.](media/ads-data-discovery-and-classification-add-classification.png "Add classification")

8. Notice the **Sales - CreditCard - CardNumber** field disappears from the recommendations list, and the number of recommendations drops by 1.

9. Select **Save** on the toolbar of the Data Classification window. It may take several minutes for the save to complete.

   ![Save the updates to the classified columns list.](media/ads-data-discovery-and-classification-save-button.png "Save")

10. Other recommendations you can review are the **HumanResources - Employee** fields for **NationIDNumber** and **BirthDate**. Note the recommendation service flagged these fields as **Confidential - GDPR**. WWI maintains data about gamers from around the world, including Europe, so having a tool that helps them discover data that may be relevant to GDPR compliance is very helpful.

    ![GDPR information is highlighted in the list of recommendations](media/ads-data-discovery-and-classification-recommendations-gdpr.png "Data Discovery & Classification")

11. Check the **Select all** checkbox at the top of the list to select all the remaining recommended classifications, and then select **Accept selected recommendations**.

12. Select **Save** on the toolbar of the Data Classification window. It may take several minutes for the save to complete.

    ![Save the updates to the classified columns list.](media/ads-data-discovery-and-classification-save.png "Save")

13. When the save completes, select the **Overview** tab on the Data Discovery & Classification blade to view a report with a full summary of the database classification state.

    ![The View Report button is highlighted on the toolbar.](media/ads-data-discovery-and-classification-overview-report.png "View report")

### Task 2: Enable Azure Defender for SQL

In this task, you enable Azure Defender for SQL for all databases on the Managed Instance.

1. In the [Azure portal](https://portal.azure.com), select **Resource groups** from the Azure services list.

   ![Resource groups is highlighted in the Azure services list.](media/azure-services-resource-groups.png "Azure services")

2. Select the hands-on-lab-SUFFIX resource group from the list.

   ![Resource groups is selected in the Azure navigation pane, and the "hands-on-lab-SUFFIX" resource group is highlighted.](./media/resource-groups.png "Resource groups list")

3. Select the **WideWorldImporters** Managed database resource from the list.

   ![The WideWorldImporters Managed Database is highlighted in the resources list.](media/resources-sql-mi-database.png "Resources")

4. On the WideWorldImporters Managed database blade, select **Security center** from the left-hand menu, under Security, and then select **Enable Azure Defender for SQL on the managed instance**.

   ![Security center is selected and highlighted in the left-hand menu of the Managed database blade, and the Enable Azure Defender for SQL on the managed instance button is highlighted.](media/sql-mi-managed-database-azure-defender-for-sql-enable.png "Azure Defender for SQL")

   >**Note**: If you do not see this button, Azure Defender for SQL may be already enabled at the subscription level. In that case, feel free to move on to the next Task.
   >
   > ![This image highlights that it is possible for Azure Defender for SQL to be enabled at the subscription-level.](./media/azure-defender-enabled-at-subscription-level.png "Subscription-level Azure Defender for SQL")

5. Within a few minutes, Azure Defender for SQL is enabled for all databases on the Managed Instance. You will see the two tiles on the Azure Defender blade become activated when it has been enabled.

### Task 3: Review an Azure Defender for SQL Vulnerability Assessment

In this task, you review an assessment report generated by Azure Defender for the `WideWorldImporters` database and take action to remediate one of the findings in the `WideWorldImporters` database. The [SQL Vulnerability Assessment service](https://docs.microsoft.com/azure/sql-database/sql-vulnerability-assessment) is a service that provides visibility into your security state and includes actionable steps to resolve security issues and enhance your database security.

1. At the bottom of the **Security center** blade for the `WideWorldImporters` Managed database, select **View additional findings in Vulnerability Assessment** in the **Vulnerability assessment findings** tile.

   ![The Vulnerability tile is displayed.](media/ads-vulnerability-assessment-tile.png "Azure Defender for SQL Vulnerability Assessment tile")

2. Select **Click here to configure a storage account for storing scan results**.

   ![This image highlights the Click here to configure a storage account for storing scan results link on the Vulnerability Assessment page.](./media/vulnerability-assessment-storage-account.png "Click here to configure a storage account for storing scan results in Vulnerability Assessment page")

3. On the **Server settings** window, select the storage account deployed with the lab and disable **Periodic recurring scans**. Then, select **Save**.

   ![This image highlights the storage account configured to store the vulnerability assessment and the Save button on the Server settings window.](./media/configure-assessment-storage-account.png "Configuring storage account on the Server settings page")

4. On the Vulnerability Assessment blade, select **Scan** on the toolbar.

   ![The Vulnerability assessment scan button is selected in the toolbar.](media/vulnerability-assessment-scan.png "Scan")

5. When the scan completes, a dashboard will display the number of failing and passing checks, along with a breakdown of the risk summary by severity level.

   ![The Vulnerability Assessment dashboard is displayed.](media/sql-mi-vulnerability-assessment-dashboard.png "Vulnerability Assessment dashboard")

6. In the scan results, browse both the Failed and Passed checks and review the types of checks that are performed. In the **Findings** list, locate the security check for **Transparent data encryption**. This check has an ID of **VA1219**.

   ![The VA1219 finding for Transparent data encryption is highlighted.](media/sql-mi-vulnerability-assessment-failed-va1219.png "Vulnerability assessment")

7. Select the **VA1219** finding to view the detailed description.

   ![The details of the VA1219 - Transparent data encryption should be enabled finding are displayed with the description, impact, and remediation fields highlighted.](media/sql-mi-vulnerability-assessment-failed-va1219-details.png "Vulnerability Assessment")

   > The details for each finding provide more insight into the reason for the finding. Of note are fields describing the finding, the impact of the recommended settings, and details on remediation for the finding.

8. You will now act on the recommended remediation steps for the finding and enable [Transparent Data Encryption](https://docs.microsoft.com/azure/azure-sql/database/transparent-data-encryption-tde-overview?tabs=azure-portal) for the `WideWorldImporters` database. To accomplish this, switch over to using SSMS on your JumpBox VM for the next few steps.

   ![The details of the VA1219 - Transparent data encryption should be enabled finding are displayed with the description, impact, and remediation fields highlighted.](media/sql-mi-vulnerability-assessment-failed-va1219-remediation.png "Vulnerability Assessment")

   > **Note**: Transparent data encryption (TDE) needs to be manually enabled for Azure SQL Managed Instance. TDE helps protect Azure SQL Database, Azure SQL Managed Instance, and Azure Data Warehouse against the threat of malicious activity. It performs real-time encryption and decryption of the database, associated backups, and transaction log files at rest without requiring changes to the application.

9. On your JumpBox VM, open **Microsoft SQL Server Management Studio 18** from the Start menu, and enter the following information in the **Connect to Server** dialog.

   - **Server name**: Enter the fully qualified domain name of your SQL managed instance, which you copied from the Azure Cloud Shell in a previous task.
   - **Authentication**: Select **SQL Server Authentication**.
   - **Login**: Enter `sqlmiuser`
   - **Password**: Enter the password used in the ARM template deployment (the default is `Password.1234567890`)
   - Check the **Remember password** box.

   ![The SQL managed instance details specified above are entered into the Connect to Server dialog.](media/ssms-18-connect-to-server.png "Connect to Server")

10. In SSMS, select **New Query** from the toolbar, paste the following SQL script into the new query window.

   ```sql
   USE WideWorldImporters;
   GO

   ALTER DATABASE [WideWorldImporters] SET ENCRYPTION ON
   ```

   > You turn transparent data encryption on and off on the database level. To enable transparent data encryption on a database in Azure SQL Managed Instance you must use T-SQL.

11. Select **Execute** from the SSMS toolbar. After a few seconds, you will see a message the "Commands completed successfully."

12. You can verify the encryption state and view information on the associated encryption keys by using the [sys.dm_database_encryption_keys view](https://docs.microsoft.com/sql/relational-databases/system-dynamic-management-views/sys-dm-database-encryption-keys-transact-sql). Select **New Query** on the SSMS toolbar again, and paste the following query into the new query window:

    ```sql
    SELECT * FROM sys.dm_database_encryption_keys
    ```

    ![The query above is pasted into a new query window in SSMS.](media/ssms-sql-mi-database-encryption-keys.png "New query")

13. Select **Execute** from the SSMS toolbar. You will see two records in the Results window, which provide information about the encryption state and keys used for encryption.

    ![The Execute button on the SSMS toolbar is highlighted, and in the Results pane the two records about the encryption state and keys for the WideWorldImporters database are highlighted.](media/ssms-sql-mi-database-encryption-keys-results.png "Results")

    > By default, service-managed transparent data encryption is used. A transparent data encryption certificate is automatically generated for the server that contains the database.

14. Return to the Azure portal and select the Azure Defender for SQL's Vulnerability Assessment blade of the `WideWorldImporters` managed database. On the toolbar, select **Scan** to start a new assessment of the database.

    ![The Vulnerability assessment scan button is selected in the toolbar.](media/vulnerability-assessment-scan.png "Scan")

15. When the scan completes, select the **Findings** tab, enter **VA1219** into the search filter box, and observe the previous failure is no longer in the findings list.

    ![The Findings tab is highlighted, and VA1219 is entered into the search filter. The list displays no results.](media/sql-mi-vulnerability-assessment-failed-filter-va1219.png "Scan Findings List")

16. Now, select the **Passed** tab, and observe the **VA1219** check is listed with a status of **PASS**.

    ![The Passed tab is highlighted, and VA1219 is entered into the search filter. VA1219 with a status of PASS is highlighted in the results.](media/sql-mi-vulnerability-assessment-passed-va1219.png "Passed")

    > Using the SQL Vulnerability Assessment, it is simple to identify and remediate potential database vulnerabilities, allowing you to improve your database security proactively.

## Exercise 6: Enable Dynamic Data Masking

Duration: 15 minutes

In this exercise, you enable [Dynamic Data Masking](https://docs.microsoft.com/azure/sql-database/sql-database-dynamic-data-masking-get-started) (DDM) on credit card numbers in the `WideWorldImporters` database. DDM limits sensitive data exposure by masking it to non-privileged users. This feature helps prevent unauthorized access to sensitive data by enabling customers to designate how much of the sensitive data to reveal with minimal impact on the application layer. It is a policy-based security feature that hides the sensitive data in the result set of a query over designated database fields while the data in the database is not changed.

For example, a call center's service representative may identify callers by several digits of their credit card number. However, the full credit card number should not be fully exposed to the service representative. A masking rule can be defined that obfuscates all but the last four digits of any credit card number in any query result. As another example, an appropriate data mask can be created to protect personally identifiable information (PII) data so that a developer can query production environments for troubleshooting purposes without violating compliance regulations.

### Task 1: Enable DDM on credit card numbers

When inspecting the data in the `WideWorldImporters` database using the ADS Data Discovery & Classification tool, you set the Sensitivity label for credit card numbers to Highly Confidential. In this task, you take another step to protect this information by enabling DDM on the `CardNumber` field in the `CreditCard` table. DDM prevents queries against that table from returning the full credit card number.

1. On your JumpBox VM, return to the SQL Server Management Studio (SSMS) window you opened previously.

2. Expand **Tables** under the **WideWorldImporters** database and locate the `Sales.CreditCard` table. Expand the table columns and observe that there is a column named `CardNumber`. Right-click the table and choose **Select Top 1000 Rows** from the context menu.

   ![The Select Top 1000 Rows item is highlighted in the context menu for the Sales.CreditCard table.](media/ssms-sql-mi-credit-card-table-select.png "Select Top 1000 Rows")

3. In the query window that opens review the Results, including the `CardNumber` field. Notice it is displayed in plain text, making the data available to anyone with access to query the database.

   ![Plain text credit card numbers are highlighted in the query results.](media/ssms-sql-mi-credit-card-table-select-results.png "Results")

4. To be able to test the mask being applied to the `CardNumber` field, you first create a user in the database to use for testing the masked field. In SSMS, select **New Query** and paste the following SQL script into the new query window:

   ```sql
   USE [WideWorldImporters];
   GO

   CREATE USER DDMUser WITHOUT LOGIN;
   GRANT SELECT ON [Sales].[CreditCard] TO DDMUser;
   ```

   > The SQL script above creates a new user in the database named `DDMUser` and grants that user `SELECT` rights on the `Sales.CreditCard` table.

5. Select **Execute** from the SSMS toolbar to run the query. You will get a message that the commands were completed successfully in the Messages pane.

6. With the new user, run a quick query to observe the results. Select **New Query** again and paste the following into the new query window.

   ```sql
   USE [WideWorldImporters];
   GO

   EXECUTE AS USER = 'DDMUser';
   SELECT TOP 10 * FROM [Sales].[CreditCard];
   REVERT;
   ```

7. Select **Execute** from the toolbar and examine the Results pane. Notice the credit card number, as above, is visible in plain text.

   ![The credit card number is unmasked in the query results.](media/ssms-sql-mi-ddm-results-unmasked.png "Query results")

8. You now apply DDM on the `CardNumber` field to prevent it from being viewed in query results. Select **New Query** from the SSMS toolbar,  paste the following query into the query window to apply a mask to the `CardNumber` field, and then select **Execute**.

   ```sql
   USE [WideWorldImporters];
   GO

   ALTER TABLE [Sales].[CreditCard]
   ALTER COLUMN [CardNumber] NVARCHAR(25) MASKED WITH (FUNCTION = 'partial(0,"xxx-xxx-xxx-",4)')
   ```

9. Run the `SELECT` query you opened in step 6 above again and observe the results. Specifically, inspect the output in the `CardNumber` field. For reference, the query is below.

   ```sql
   USE [WideWorldImporters];
   GO

   EXECUTE AS USER = 'DDMUser';
   SELECT TOP 10 * FROM [Sales].[CreditCard];
   REVERT;
   ```

   ![The credit card number is masked in the query results.](media/ssms-sql-mi-ddm-results-masked.png "Query results")

   > The `CardNumber` is now displayed using the mask applied to it, so only the card number's last four digits are visible. Dynamic Data Masking is a powerful feature that enables you to prevent unauthorized users from viewing sensitive or restricted information (`sqlmiuser` can view the data without the mask). It's a policy-based security feature that hides the sensitive data in the result set of a query over designated database fields while the data in the database is not changed.

### Task 2: Apply DDM to email addresses

From the findings of the Data Discovery & Classification report in Azure Defender for SQL, you saw that email addresses are labeled Confidential. In this task, you use one of the built-in functions for making email addresses using DDM to help protect this information.

1. For this, you target the `LoginEmail` field in the `[dbo].[Gamer]` table. Open a new query window and execute the following script:

   ```sql
   USE [WideWorldImporters];
   GO

   SELECT TOP 10 * FROM [dbo].[Gamer]
   ```

   ![In the query results, full email addresses are visible.](media/ddm-select-gamer-results.png "Query results")

2. Now, as you did above, grant the `DDMUser` `SELECT` rights on the [dbo].[Gamer]. In a new query window and enter the following script, and then select **Execute**:

   ```sql
   USE [WideWorldImporters];
   GO

   GRANT SELECT ON [dbo].[Gamer] to DDMUser;
   ```

3. Next, apply DDM on the `LoginEmail` field to prevent it from being viewed in full in query results. Select **New Query** from the SSMS toolbar, paste the following query into the query window to apply a mask to the `LoginEmail` field, and then select **Execute**.

   ```sql
   USE [WideWorldImporters];
   GO

   ALTER TABLE [dbo].[Gamer]
   ALTER COLUMN [LoginEmail] NVARCHAR(250) MASKED WITH (FUNCTION = 'Email()');
   ```

   > **Note**: Observe the use of the built-in `Email()` masking function above. This masking function is one of several pre-defined masks available in SQL Server databases.

4. Run the `SELECT` query below and observe the results. Specifically, inspect the output in the `LoginEmail` field. For reference, the query is below.

   ```sql
   USE [WideWorldImporters];
   GO

   EXECUTE AS USER = 'DDMUser';
   SELECT TOP 10 * FROM [dbo].[Gamer];
   REVERT;
   ```

   ![The email addresses are masked in the query results.](media/ddm-select-gamer-results-masked.png "Query results")

## Exercise 7: Use online secondary for read-only queries

Duration: 15 minutes

In this exercise, you examine how you can use the automatically created online secondary for reporting without feeling the impacts of a heavy transactional load on the primary database. Each database in the SQL MI Business Critical tier is automatically provisioned with several AlwaysON replicas to support the availability SLA. Using [**Read Scale-Out**](https://docs.microsoft.com/azure/sql-database/sql-database-read-scale-out) allows you to load balance Azure SQL Database read-only workloads utilizing the capacity of one read-only replica.

### Task 1: View Leaderboard report in the WideWorldImporters web application

In this task, you open a web report using the web application you deployed to your App Service.

1. In the [Azure portal](https://portal.azure.com), select **Resource groups** from the Azure services list.

   ![Resource groups is highlighted in the Azure services list.](media/azure-services-resource-groups.png "Azure services")

2. Select the hands-on-lab-SUFFIX resource group from the list.

   ![Resource groups is selected in the Azure navigation pane, and the "hands-on-lab-SUFFIX" resource group is highlighted.](./media/resource-groups.png "Resource groups list")

3. In the hands-on-lab-SUFFIX resource group, select the **wwi-web-UNIQUEID** App Service from the list of resources.

   ![The App Service resource is selected from the list of resources in the hands-on-lab-SUFFIX resource group.](media/rg-app-service.png "hands-on-lab-SUFFIX resource group")

4. On the App Service overview blade, select the **URL** to open the web application in a browser window.

   ![The App service URL is highlighted.](media/app-service-url.png "App service URL")

5. In the WideWorldImporters web app, select **Leaderboard** from the menu.

   ![READ_WRITE is highlighted on the Leaderboard page.](media/gamer-leaderboard-read-write.png "Gamer Leaderboard within the Web App")

   > Note the `READ_WRITE` string on the page. This message is the output from reading the `Updateability` property associated with the `ApplicationIntent` option on the target database. This can be retrieved using the SQL query `SELECT DATABASEPROPERTYEX(DB_NAME(), "Updateability")`.

### Task 2: Update read-only connection string

In this task, you enable Read Scale-Out for the `WideWorldImporters`database, using the `ApplicationIntent` option in the connection string. This option dictates whether the connection is routed to the write replica or a read-only replica. Specifically, if the `ApplicationIntent` value is `ReadWrite` (the default value), the connection is directed to the database's read-write replica. If the `ApplicationIntent` value is `ReadOnly`, the connection is routed to a read-only replica.

1. Return to the App Service blade in the Azure portal and select **Configuration** under Settings on the left-hand side.

   ![The Configuration item is selected under Settings.](media/app-service-configuration-menu.png "Configuration")

2. On the Configuration blade, scroll down and locate the connection string named `WwiReadOnlyContext` within the **Connection strings** section, and select the Pencil (edit) icon on the right.

   ![The edit icon next to the read-only connection string is highlighted.](media/app-service-configuration-connection-strings-read-only.png "Connection strings")

3. In the Add/Edit connection string dialog, select the **Value** for the `WwiReadOnlyContext` and paste the following parameter to the end of the connection string.

   ```sql
   ApplicationIntent=ReadOnly;
   ```

4. The `WwiReadOnlyContext` connection string should now look something like the following:

   ```sql
   Server=tcp:sqlmi-kmtwpw3nia6n2.15b8611394c5.database.windows.net,1433;Database=WideWorldImporters;User ID=sqlmiuser;Password=Password.1234567890;Trusted_Connection=False;Encrypt=True;TrustServerCertificate=True;ApplicationIntent=ReadOnly;
   ```

5. Select **OK**.

6. Select **Save** at the top of the Configuration blade and select **Continue** when prompted about restarting the application.

   ![The save button on the Application settings blade is highlighted.](media/app-service-configuration-save.png "Save")

### Task 3: Reload Leaderboard report in the web app

In this task, you refresh the Leaderboard report in the WideWorldImporters web app and observe the result.

1. Return to the gamer information website you opened previously and refresh the **Leaderboard** page. The page should now look similar to the following:

   ![READ_ONLY is highlighted on the Reports page.](media/gamer-leaderboard-read-only.png "Gamer Leaderboard Web App")

   > Notice the `updateability` option is now displaying as `READ_ONLY`. With a simple addition to your database connection string, queries can be sent to an online secondary of your SQL MI Business-critical database. This setting allows for load-balancing read-only workloads using the capacity of one read-only replica. The SQL MI Business Critical cluster has a built-in Read Scale-Out capability that provides a free-of-charge built-in read-only node that can be used to run read-only queries that should not affect the performance of your primary workload.

## After the hands-on lab

Duration: 10 minutes

In this exercise, you will de-provision all Azure resources that you created in support of this hands-on lab.

### Task 1: Delete Azure resource groups

1. In the Azure portal, select **Resource groups** from the left-hand menu, and locate and delete the **hands-on-lab-SUFFIX** following resource group.

   > **Note**: Deleting a resource group containing SQL MI does not always work the first time. The deletion failure can result in a few networking components (route table, SQL MI NSG, and VNet) remaining in the resource group, along with the SQL MI instance, after the first delete attempt. In this case, wait for the first process to complete, and then attempt to delete the resource group a second time. _You may need to allow several hours or more between delete attempts_.

### Task 2: Delete the wide-world-importers service principal

1. In the Azure portal, select **Azure Active Directory** and then select **App registrations**.

2. Select the **wide-world-importers** application and select **Delete** on the application blade.

You should follow all steps provided _after_ attending the Hands-on lab.
