# Automated Zimbra Installer

Zimbra silent installer using a keystroke file. Installs the 8.8.9 open source edition for Ubuntu 16.04. 

TODO:
- Get hostname and domain information (no hard-coding)
- Get proper timezone
- Check for different Ubuntu versions
- Add check for Open Source or Network Trial


# Azure Auto-Deploy
## blah blah

# Deploy a Zimbra Collaboration Server Network Edition on Ubuntu.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https://raw.githubusercontent.com/zdocs/auto-install/master/azuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/zdocs/auto-install/master/azuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template uses the Azure Linux CustomScript extension to deploy a Zimbra on Ubuntu. It creates an Ubuntu VM (16.04), does a silent install of Zimbra Network Edition 8.8.9 with a trial license.
