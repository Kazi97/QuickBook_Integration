Remember before deploying in your org:
1. This is a custom Auth provider to connect Quickboos with salesforce.
2. After deploying the custom metadata types (QB_Metadata__mdt) and the two apex classes (QuickBook, QB_UserWrapper)
3. QuickBook will be available in 'Auth Provider' option.
4. Now fill in the required fields leaving 'State' and 'Security' token.
5. Add the required URLs in Remote Site Settings and then Create NamedCredentials.
6. Don't forget to enter the callback url in QuickBook portal.
7. Now make your desired API requests. 

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

Remember before deploying in your org:
1. This is a custom Auth provider to connect Quickboos with salesforce.
2. After deploying the custom metadata types (QB_Metadata__mdt) and the two apex classes (QuickBook, QB_UserWrapper)
3. QuickBook will be available in 'Auth Provider' option.
4. Now fill in the required fields leaving 'State' and 'Security' token.
5. Add the required URLs in Remote Site Settings and then Create NamedCredentials.
6. Don't forget to enter the callback url in QuickBook portal.
7. Now make your desired API requests. 