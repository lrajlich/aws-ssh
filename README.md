## Description
This project is meant to facilitate ssh'ing into aws servers. Uses ec2 describe-instances to build a map of instance name to ssh host. Subsequently, a user can ssh using the instance name.

## Install
### Install steps for OSX
Install homebrew
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
This library requires awscli (http://docs.aws.amazon.com/cli/latest/index.html) and jq (http://stedolan.github.io/jq/). Awscli can be installed via pip (which in turn can be installed via brew) and jq can be installed via brew.
```
brew install python
pip3 install awscli
brew install jq
git clone git@github.com:dealpath/aws-ssh.git
cd aws-ssh
make install
```
## Configure AWS cli
Make sure your AWS cli is configured, following steps here: (http://docs.aws.amazon.com/cli/latest/reference/configure/index.html)
Make your .aws folder and go into it
```
mkdir ~/.aws
cd ~/.aws
```
Create the ```config``` file with the following:
```
[default]
region=us-west-2
```
Create the ```credentials``` file with the following:
```
[default]
aws_access_key_id=
aws_secret_access_key=
```
And enter your IAM user key id and secret from the .csv file received from DevOPs

You should also receive a ```dealpath.pem``` file which you should also place within ```~/.aws```

Once you are done with configuration, run ```aws ec2 describe-instances``` to test

## Configure aws-ssh

In addition, this project has a "config" file, in the root folder of the project, to be modified as needed, with 3 parameters. You should ask someone for the specifics of user/pem as this is shared across the team:
 1. ```user``` - user used to connect to AWS hosts. This should be "ubuntu".
 2. ```pem``` - pem file used for ssh key authentication with aws servers
 3. ```host_xpath``` - Host to determine the host from the output of describe-instances. Some examples:
   * ```.PublicIpAddress``` - Use Public ip address as ssh host
   * ```.PrivateIpAddress``` - Use Private IP Address as ssh host
   * ```.PublicDnsName``` - Use Public DNS name as ssh host
   * ```.PrivateDnsName``` - Use Private DNS name as ssh host

If you edit the config file from the directory you git cloned into, you will have to run ```make install``` again as the config used by the command line is in the installed directory - /usr/local/aws-ssh/config (which installed via Make install).

Once you are done configuring aws-ssh, run ```aws-ssh ls``` to test the configuration and refresh your local server list

## Usage
#### Show options
* ```aws-ssh help``` show available commands

#### List servers
* ```aws-ssh ls``` show a list of aws instances
```
LUKEs-MacBook-Pro:~ lrajlich$ aws-ssh ls
app-01
app-02
app-03
consumer-01
consumer-02
consumer-03
resque-01
```
* ```aws-ssh ls --help``` Show list of options
  * ```-d``` show details like instance id and ip address. Tab delimited
  * ```-r``` manually refresh the instance list (by default, it will use local cached list for speed)

#### Connect to server
* ```aws-ssh app-01``` Connect to server named app-01
  * This operates on grepping for the string, so things like ```aws-ssh con.*-01``` will work
  * You can also connect using instance_id or ip address from ```aws-ssh ls -d```

#### Scripting Examples
Scripting is fairly straightforward - ```aws-ssh ls -d``` is tab delimited and can be used for a number of use cases
* ```aws-ssh ls -d | grep app-01 | cut -f 2``` Get instance id for app-01, usage for AWS api operations on that server
* ```aws-ssh ls -d | cut -f 3 | perl -pe "s/\n/,/g"``` Get comma seperated list of ip address, which can be used as argument to [pdsh -w](http://linux.die.net/man/1/pdsh parameter)

## Auto-refresh
You can have aws-ssh updates it's listing automatically, though this requires a manual step. This is run off a cron job. First you need to create log directories for aws-ssh auto refresh. When auto refresh runs, any stdout and stderr will be written to this location.
```
sudo mkdir -p /var/log/aws-ssh
sudo chown `whoami` /var/log/aws-ssh
```

#### Create cron job fo OSX 
run ```crontab -e```. In Vim, enter the following line
```
*/5 * * * * /usr/local/aws-ssh/aws-ssh-auto-refresh >> /var/log/aws-ssh/cron.log 2>> /var/log/aws-ssh/cron.log
```
Press ```esc``` and then ```ZZ```. This will install your cron tab (if you don't have one). Otherwise, you can do a simple write+quit vim operation.
