#!/bin/bash

# Copyright (c) 2015-2024 Michael Neill Hartman. All rights reserved.
# mnh_license@proton.me
# https://github.com/hartmanm

# bash wmnh.sh <SOURCE_URL>

# to download and source your config.sh and mnh.sh

SOURCE_URL="$1"
CONFIG=`echo "$SOURCE_URL" | tr '/' ' ' | awk '{print $NF}'`
[[ -e $CONFIG ]] && rm $CONFIG
export CONFIG
wget $SOURCE_URL 
source $CONFIG
source mnh.sh 

d
