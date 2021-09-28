#!/bin/bash

set -ex

# Check For First Time Setup
# If setup file exists, run normally
if test -f "$SETUP_FILE"; then

    # Start protonmail
    # Fake a terminal, so it does not quit because of EOF...
    rm -f fake_terminal
    mkfifo fake_terminal
    cat fake_terminal | /proton/proton-bridge --cli $@

# Otherwise
else

    # Create setup file, will be empty, just using its existance as a boolean
    touch $SETUP_FILE

    # Initialize pass
    gpg --generate-key --batch /proton/gpgparams
    pass init pass-key

    # Start protonmail
    # Fake a terminal, so it does not quit because of EOF...
    rm -f fake_terminal
    mkfifo fake_terminal
    cat fake_terminal | /proton/proton-bridge --cli $@

fi