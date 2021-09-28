#!/bin/bash

set -ex

# Check For First Time Setup
# If setup file exists, run normally
if test -f "$SETUP_FILE"; then

    /proton/proton-bridge --cli $@

# Otherwise
else

    # Create setup file, will be empty, just using its existance as a boolean
    touch $SETUP_FILE

    # Initialize pass
    gpg --generate-key --batch /proton/gpgparams
    pass init pass-key

    # Login
    /proton/proton-bridge --cli $@

fi