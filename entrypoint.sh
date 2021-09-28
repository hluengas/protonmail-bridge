#!/bin/bash

set -ex

# Check For First Time Setup
if [[ $SETUP == "false" ]]; then

    /protonmail/proton-bridge --cli $@

# Otherwise
else

    # Initialize pass
    gpg --generate-key --batch /protonmail/gpgparams
    pass init pass-key

    # Login
    /protonmail/proton-bridge --cli $@

fi