## Description
This project is meant to facilitate ssh'ing into aws servers. 

## Install
### Install steps for OSX
This library requires awscli (http://docs.aws.amazon.com/cli/latest/index.html) and jq (http://stedolan.github.io/jq/). Awscli can be installed via pip (which in turn can be installed via brew) and jq can be installed via brew.
```
brew install pip
pip install awscli
brew install jq
git clone
cd 
make install
```
## Configure
Make sure your AWS cli is configured, following steps here: 
In addition, this project has a "config" file, in the root folder of the project, to be modified as needed, with 3 parameters:
1. ```user``` - user used to connect to AWS hosts
2. ```pem``` - pem file used for ssh key authentication with aws servers
3. ```host_xpath``` - Host to determine the host from the 
  * ```.PublicIpAddress``` - Public ip address of the isntance
  *
### Example configuration
```
user=ubuntu
pem=~/.aws/dealpath.pem
host_xpath=.PublicIpAddress
```
user - user you use to connec to 
host_xpath
