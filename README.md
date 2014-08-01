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
 3. ```host_xpath``` - Host to determine the host from the output of describe-instances. Some examples:
   * ```.PublicIpAddress``` - Public ip address
   * ```.PrivateIpAddress``` - Private IP Address
   * ```.PublicDnsName``` - Public DNS name
   * ```.PrivateDnsName``` - Private DNS name

## Example Usage
First, you must run "ls" to refresh the local list of instances
```
LUKEs-MacBook-Pro:aws-ssh lrajlich$ aws-ssh ls
thewall-test
thewall-01
winterfell-01
thewall-02
winterfell-02
```
Then, run a command and specify and instance name to connect to that host
```
LUKEs-MacBook-Pro:aws-ssh lrajlich$ aws-ssh thewall-05
```
