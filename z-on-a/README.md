# A sample to run scripts in public storage using CustomScript Extension

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fzdocs%2Fauto-install%2Fmaster%2Fz-on-a%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fzdocs%2Fauto-install%2Fmaster%2Fz-on-a%2Fazuredeploy.json"" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template uses the Azure Linux [CustomScript Extension](https://github.com/Azure/azure-linux-extensions/tree/master/CustomScript) to deploy and install Zimbra on Ubuntu. It creates an Ubuntu VM (16.04), does a silent install of Zimbra Network Edition 8.8.9 with a trial license.
