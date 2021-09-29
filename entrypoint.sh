#!/usr/bin/bash

# Check For First Time Setup
# If setup file exists, run normally
if [ $LOGIN == "false" ]; then

    if [ $INTERACTIVE == "false"]; then
        
        /proton/proton-bridge --noninteractive
    
    else

        /proton/proton-bridge --cli
        
    fi

else 
    expect /proton/login.sh
fi