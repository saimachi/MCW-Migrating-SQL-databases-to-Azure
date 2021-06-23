![Microsoft Cloud Workshops](https://github.com/Microsoft/MCW-Template-Cloud-Workshop/raw/main/Media/ms-cloud-workshop.png "Microsoft Cloud Workshops")

<div class="MCWHeader1">
Migrating SQL databases to Azure
</div>

<div class="MCWHeader2">
Before the hands-on lab setup guide
</div>

<div class="MCWHeader3">
June 2021
</div>

Information in this document, including URL and other Internet Web site references, is subject to change without notice. Unless otherwise noted, the example companies, organizations, products, domain names, e-mail addresses, logos, people, places, and events depicted herein are fictitious, and no association with any real company, organization, product, domain name, e-mail address, logo, person, place or event is intended or should be inferred. Complying with all applicable copyright laws is the responsibility of the user. Without limiting the rights under copyright, no part of this document may be reproduced, stored in or introduced into a retrieval system, or transmitted in any form or by any means (electronic, mechanical, photocopying, recording, or otherwise), or for any purpose, without the express written permission of Microsoft Corporation.

Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in this document. Except as expressly provided in any written license agreement from Microsoft, the furnishing of this document does not give you any license to these patents, trademarks, copyrights, or other intellectual property.

The names of manufacturers, products, or URLs are provided for informational purposes only and Microsoft makes no representations and warranties, either expressed, implied, or statutory, regarding these manufacturers or the use of the products with any Microsoft technologies. The inclusion of a manufacturer or product does not imply endorsement of Microsoft of the manufacturer or product. Links may be provided to third party sites. Such sites are not under the control of Microsoft and Microsoft is not responsible for the contents of any linked site or any link contained in a linked site, or any changes or updates to such sites. Microsoft is not responsible for webcasting or any other form of transmission received from any linked site. Microsoft is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement of Microsoft of the site or the products contained therein.

© 2020 Microsoft Corporation. All rights reserved.

Microsoft and the trademarks listed at <https://www.microsoft.com/en-us/legal/intellectualproperty/Trademarks/Usage/General.aspx> are trademarks of the Microsoft group of companies. All other trademarks are property of their respective owners.

**Contents**

<!-- TOC -->

- [Contents](#contents)
- [Migrating SQL databases to Azure before the hands-on lab setup guide](#migrating-sql-databases-to-azure-before-the-hands-on-lab-setup-guide)
  - [Requirements](#requirements)
  - [Before the hands-on lab](#before-the-hands-on-lab)
- [Task 1: Create a resource group](#task-1-create-a-resource-group)
- [Task 2: Register the Microsoft DataMigration resource provider](#task-2-register-the-microsoft-datamigration-resource-provider)
- [Task 3: Validate subscription compatibility with SQL MI](#task-3-validate-subscription-compatibility-with-sql-mi)
- [Task 4: Run ARM template to provision lab resources](#task-4-run-arm-template-to-provision-lab-resources)

<!-- /TOC -->

# Migrating SQL databases to Azure before the hands-on lab setup guide

## Requirements

- Microsoft Azure subscription must be pay-as-you-go or MSDN.
  - Trial subscriptions will _not_ work.

> **Important**: You must have sufficient rights within your Azure AD tenant to create an Azure Active Directory application and service principal and assign roles on your subscription to complete this hands-on lab.

## Before the hands-on lab

Duration: 15 minutes

In this exercise, you set up your environment for use in the rest of the hands-on lab. You should follow all steps provided _before_ attending the Hands-on lab.

> **Important**: Many Azure resources require globally unique names. Throughout these steps, the word "SUFFIX" appears as part of resource names. You should replace this with your Microsoft alias, initials, or other value to ensure uniquely named resources.

### Task 1: Create a resource group

1. In the [Azure portal](https://portal.azure.com), select **Resource groups** from the Azure services list.

   ![Resource groups is highlighted in the Azure services list.](media/azure-services-resource-groups.png "Navigate to resource group")

2. On the Resource groups blade, select **+ Create**.

   ![Create is highlighted in the toolbar on Resource groups blade.](media/resource-groups-add.png "Create resource group")

3. On the Create a resource group **Basics** tab, enter the following:

   - **Subscription**: Select the subscription you are using for this hands-on lab.
   - **Resource group**: Enter `hands-on-lab-SUFFIX` as the name of the new resource group.
   - **Region**: Select the region you are using for this hands-on lab.

   ![The values specified above are entered into the Create a resource group Basics tab.](media/create-resource-group.png "Create resource group")

4. Select **Review + Create**.

5. On the **Review + create** tab, ensure the Validation passed message is displayed and then select **Create**.

### Task 2: Register the Microsoft DataMigration resource provider

In this task, you register the `Microsoft.DataMigration` resource provider with your Azure subscription. Registration of this resource provider is necessary to create an Azure Database Migration Service within your subscription.

1. In the [Azure portal](https://portal.azure.com), from **home page**, select **Subscriptions** from the Azure services list.

   ![Subscriptions is highlighted in the Azure services list.](media/azure-services-subscriptions.png "Azure services")

2. Select the subscription you are using for this hands-on lab from the list.

   ![The target subscription is highlighted in the subscriptions list.](media/azure-subscriptions.png "Subscriptions list")

3. On the Subscription blade, select **Resource providers** from the left-hand menu and then enter "migration" into the filter box.

   ![Resource providers is highlighted in the left-hand menu of the Subscription blade. On the Resource providers blade, migration is entered into the filter box.](media/azure-portal-subscriptions-resource-providers-register-microsoft-datamigration.png "Resource provider registration")

4. If the `Microsoft.DataMigration` provider's status is `NotRegistered`, select **Register** in the toolbar.

   ![The Register button is highlighted in the Resource Providers toolbar.](media/azure-subscriptions-resource-providers-toolbar.png "Resource providers toolbar")

5. It can take a couple of minutes for the registration to complete. Make sure you see the status set to **Registered** before moving on. You may need to select **Refresh** on the toolbar to see the updated status.

   ![Registered is highlighted next to the Microsoft.DataMigration resource provider.](media/resource-providers-datamigration-registered.png "Microsoft DataMigration Resource Provider")

### Task 3: Validate subscription compatibility with SQL MI

Before running the ARM template, it is beneficial to quickly verify that you can provision SQL Managed Instance in your subscription.

1. In the [Azure portal](https://portal.azure.com), select **+Create a resource**.

   ![Create a resource from Azure Portal home page.](media/create-a-resource.png "Create a resource")

2. Enter **sql managed instance** into the Search the Marketplace box.
3. Then select **Azure SQL Managed Instance** from the results.

   ![+Create a resource is selected in the Azure navigation pane, and "sql managed instance" is entered into the Search the Marketplace box. Azure SQL Managed Instance is selected in the results.](media/create-resource-sql-mi.png "Create SQL Managed Instance")

4. Select **Create** on the Azure SQL Managed Instance blade.

   ![The Create button is highlighted on the Azure SQL Managed Instance blade.](media/sql-mi-create.png "Create Azure SQL Managed Instance")

5. On the SQL managed instance blade, look for a message stating that "Managed instance creation is not available for the chosen subscription type...", which will be displayed near the bottom of the SQL managed instance blade.

   ![A message is displayed stating that SQL MI creation not available in the selected subscription.](media/sql-mi-creation-not-available.png "SQL MI creation not available")

   > **Note**: If you see the message stating that Managed Instance creation is not available for the chosen subscription type, follow the instructions for [obtaining a larger quota for SQL Managed Instance](https://docs.microsoft.com/azure/sql-database/sql-database-managed-instance-resource-limits#obtaining-a-larger-quota-for-sql-managed-instance) before proceeding with the following steps.

6. Be happy if you don't have any warning! Just **cancel** current operation by closing blade.

   ![The closing button is located on top left below user name.](media/cancel-resource-sql-mi.png "Cancel SQL MI resource creation")

### Task 4: Run ARM template to provision lab resources

In this task, you run an Azure Resource Manager (ARM) template to create the resources required for this hands-on lab. The components are deployed inside a new virtual network (VNet) to facilitate communication between the VMs and SQL MI. The ARM template also adds inbound and outbound security rules to the network security groups associated with SQL MI and the VMs, including opening port 3389 to allow RDP connections to the JumpBox. In addition to creating resources, the ARM template also executes PowerShell scripts on each of the VMs to install software and configure the servers. The resources created by the ARM template include:

- A virtual network with three subnets, ManagedInstance, Management, and a Gateway subnet.
- A virtual network gateway associated with the Gateway subnet.
- A route table.
- Azure SQL Managed Instance (SQL MI), added to the ManagedInstance subnet.
- A JumpBox with Visual Studio 2019 Community Edition and SQL Server Management Studio (SSMS installed, added to the Management subnet).
- A SQL Server 2008 R2 VM with the Data Migration Assistant (DMA) installed, added to the Management subnet.
- Azure Database Migration Service (DMS).
- Azure App Service Plan and App Service (Web App).
- Azure Blob Storage account.

> **Note**: You can review the steps to manually provision and configure the lab resources in the [Manual resource setup guide](./Manual-resource-setup.md).

You are now ready to begin the ARM template deployment.

1. To open a custom deployment screen in the Azure portal, use Azure search bar and type **deploy**:
2. Select the **Deploy a custom template** service in search results.

   ![Deploy a custom template by using search bar.](media/deploy-custom-template.png "Deploy custom template")

   > **Note**: Running the ARM template occasionally results in a `ResourceDeploymentFailure` error, with a code of `VnetSubnetConflictedWithIntendedPolicy`. This error is not caused by an issue with the ARM template and appears to be the result of backend resource deployment issues in Azure. At this time, the workaround is first to try the deployment in a different region. If that does not work, try going through the [Manual resource setup guide](./Manual-resource-setup.md) to create the SQL MI database.

3. On the custom deployment screen, select the **Build your own template in the editor** button.

   ![Locate and select the Build your own template in the editor button.](media/build-template-button.png "Build template button")

4. Whether use **Load file** button or paste content from file **Hands-on lab/lab-files/ARM-template/azure-deploy.json** from repository.

5. Then use **Save** button to validate template.

   ![Load file or paste content from lab file azure-deploy.json from ARM-template folder .](media/load-template-file.png "Load template file")

6. On the next custom deployment, first check that **19 resources** are about to be created.

7. Only fill **two settings** into deployment form, and **leave others as default**:

   - **Resource group**: Select the hands-on-lab-SUFFIX resource group from the dropdown list.
   - **Managed Instance Name**: Ensure globally unique value, such as **sqlmi-SUFFIX**.

8. Then select **Review + create** to review the custom deployment.

   ![The Custom deployment blade is displayed, and the information above is entered on the Custom deployment blade.](media/azure-custom-deployment.png "Custom deployment blade")

9. Wait for the **Review + create** blade to refresh, and ensure the _Validation passed_ message is displayed. Finally  select **Create** to begin the custom deployment.

   ![On the Review + create blade for the custom deployment, the Validation passed message is highlighted, and the Create button is highlighted.](media/azure-custom-deployment-review-create.png "Review + create custom deployment")

   > **Note**: The deployment of the custom ARM template can take over 4 hours due to the inclusion of SQL MI. However, the deployment of most of the resources completes within a few minutes. The JumpBox and SQL Server 2008 R2 VMs should finish in about 15 minutes.

10. You can monitor the deployment's progress any time by navigating to the **hands-on-lab-SUFFIX** resource group in the Azure portal and then selecting **Deployments** from the left-hand menu. The deployment is named **Microsoft.Template-xxxxxxx**. Select that to view the progress of each item in the template.

   ![The Deployments menu item is selected in the left-hand menu of the hands-on-lab-SUFFIX resource group and the Microsoft.Template deployment is highlighted.](media/resource-group-deployments.png "Resource group deployments")

> Check back in a few hours to monitor the progress of your SQL MI provisioning. If the provisioning goes on for longer than 7 hours, you may need to issue a support ticket in the Azure portal to request the provisioning process be unblocked by Microsoft support.

> **Important**
>
> As soon as the SqlServer2008 VM is up, you should check if that `WideWorldImporters` database is up. Indeed, the configuration script used by the ARM template may have failed during the VM setup. In this case, you should follow the steps under Task 12 of the [Manual-resource-setup guide](./Manual-resource-setup.md) to **manually restore and configure the database**.

You should follow all steps provided *before* performing the Hands-on lab.
