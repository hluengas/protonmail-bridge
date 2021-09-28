#!/bin/bash

set -ex

# Check For First Time Setup
# If setup file exists, run normally
if test -f "$SETUP_FILE"; then

    /protonmail/proton-bridge --cli $@

# Otherwise
else

    # Create setup file, will be empty, just using its existance as a boolean
    touch $SETUP_FILE

    # Initialize pass
    gpg --generate-key --batch /protonmail/gpgparams
    pass init pass-key

    # Login
    /protonmail/proton-bridge --cli $@

fi