#!/bin/bash

## Arguments
# aws_ssh_data_dir - sourced (runtime)
# instance_name - sourced (runtime, commandline argument)
# user - sourced (config)
# pem -sourced (config)

host=`cat ./data/listing | grep prod-thewall-04 | cut -f 2 -d "="`
echo Connect to $instance_name - $host
ssh -i ${pem} ${user}@$host
