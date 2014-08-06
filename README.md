## Description
This project is meant to facilitate ssh'ing into aws servers. Uses ec2 describe-instances to build a map of instance name to ssh host. Subsequently, a user can ssh using the instance name.

## Install
### Install steps for OSX
This library requires awscli (http://docs.aws.amazon.com/cli/latest/index.html) and jq (http://stedolan.github.io/jq/). Awscli can be installed via pip (which in turn can be installed via brew) and jq can be installed via brew.
```
brew install pip
pip install awscli
brew install jq
git clone git@github.com:lrajlich/aws-ssh.git
cd aws-ssh
make install
```
## Configure
Make sure your AWS cli is configured, following steps here: (http://docs.aws.amazon.com/cli/latest/reference/configure/index.html)

In addition, this project has a "config" file, in the root folder of the project, to be modified as needed, with 3 parameters:
 1. ```user``` - user used to connect to AWS hosts
 2. ```pem``` - pem file used for ssh key authentication with aws servers
 3. ```host_xpath``` - Host to determine the host from the output of describe-instances. Some examples:
   * ```.PublicIpAddress``` - Use Public ip address as ssh host
   * ```.PrivateIpAddress``` - Use Private IP Address as ssh host
   * ```.PublicDnsName``` - Use Public DNS name as ssh host
   * ```.PrivateDnsName``` - Use Private DNS name as ssh host

If you edit the config file from the directory you git cloned into, you will have to run "make install" again as the config used by the command line is in the installed directory - /usr/local/aws-ssh/config (which installed via Make install).

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
LUKEs-MacBook-Pro:aws-ssh lrajlich$ aws-ssh thewall-02
```
## Auto-refresh
You can have aws-ssh updates it's listing automatically, though this requires a manual step. This is run off a cron job. First you need to create log directories for aws-ssh auto refresh. When auto refresh runs, any stdout and stderr will be written to this location.
```
sudo mkdir -p /var/log/aws-ssh
sudo chown `whoami` /var/log/aws-ssh
```

### Create cron job fo OSX 
run ```crontab -e```. In Vim, enter the following line
```
*/5 * * * * /usr/local/aws-ssh/aws-ssh-auto-refresh >> /var/log/aws-ssh/cron.log 2>> /var/log/aws-ssh/cron.log
```
Press ```esc``` and then ```ZZ```. This will install your cron tab (if you don't have one). Otherwise, you can do a simple write+quit vim operation.
