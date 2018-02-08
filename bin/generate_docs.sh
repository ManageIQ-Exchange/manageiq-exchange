#!/bin/bash
INPUT=app
OUTPUT=docs
MY_PATH=`dirname $0`              # relative
MY_PATH=$( cd $MY_PATH/.. && pwd ) 
echo Generating documentation outpout in $MY_PATH/$OUTPUT
apidoc -i $MY_PATH/$INPUT -o $MY_PATH/$OUTPUT
