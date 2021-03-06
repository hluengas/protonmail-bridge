#!/usr/bin/bash

# Check For First Time Setup
# If setup file exists, run normally
if [ $LOGIN == "false" ]; then

    # socat will make the connection appear to come from 127.0.0.1
    # ProtonMail Bridge currently expects that.
    socat TCP-LISTEN:25,fork TCP:127.0.0.1:1025 &
    socat TCP-LISTEN:143,fork TCP:127.0.0.1:1143 &

    if [ $INTERACTIVE == "false" ]; then
        
        /proton/proton-bridge --noninteractive
    
    else

        /proton/proton-bridge --cli
        
    fi

else 
    expect /proton/login.sh
fi