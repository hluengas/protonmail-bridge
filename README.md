# ProtonMail Bridge

Debian Docker container for running headless ProtonMail Bridge

## Environment Variables:

**LOGIN:**

Boolean. If "true" run the login setup script. If "false" run bridge normally. Value defaults to "false".

**INTERACTIVE:**

Boolean. If "true" bridge is run with the --cli parameter. If "false" bridge is run with the --noninteractive parameter. In CLI mode the bridge will exit automatically after a period of inactivity. Value defaults to "false".

**USERNAME:**

ProtonMail Credentials: username. Value only used in the login script.

**PASSWORD:**

ProtonMail Credentials: password. Value only used in the login script.

**2FA_CODE:**

ProtonMail Credentials: authenticator code. This value is highly time sensitive. Value only used if provided. Value only used in the login script.

## Setup

To setup the container, set the LOGIN variable to "true". Also add approriate credential values to their corresponding environment variables. You must also map a persitant volume for /root within the container, this will hold the keyring and config files.

EX

    docker run --name="protonmail-bridge-container" -e LOGIN="true" -e USERNAME="myusername" -e PASSWORD="mypassword" -e 2FA_CODE="123456" -v /path/on/host/appdata/proton:/root:rw hluengas/protonmail-bridge:latest

The container will intialize pass. Then run bridge and attempt to login. The output should look like this:

    spawn gpg --generate-key --batch /proton/gpgparams
    gpg: directory '/root/.gnupg' created
    gpg: keybox '/root/.gnupg/pubring.kbx' created
    gpg: Generating a basic OpenPGP key
    gpg: /root/.gnupg/trustdb.gpg: trustdb created
    gpg: key 85E29B15400EA638 marked as ultimately trusted
    gpg: directory '/root/.gnupg/openpgp-revocs.d' created
    gpg: revocation certificate stored as '/root/.gnupg/openpgp-revocs.d/C7C86A1322094F2654FA187585E29B15400EA638.rev'
    gpg: done
    spawn pass init pass-key
    mkdir: created directory '/root/.password-store/'
    Password store initialized for pass-key
    spawn /proton/proton-bridge --cli

                Welcome to ProtonMail Bridge interactive shell
                                ___....___
        ^^                __..-:'':__:..:__:'':-..__
                    _.-:__:.-:'':  :  :  :'':-.:__:-._
                    .':.-:  :  :  :  :  :  :  :  :  :._:'.
                _ :.':  :  :  :  :  :  :  :  :  :  :  :'.: _
                [ ]:  :  :  :  :  :  :  :  :  :  :  :  :  :[ ]
                [ ]:  :  :  :  :  :  :  :  :  :  :  :  :  :[ ]
    :::::::::[ ]:__:__:__:__:__:__:__:__:__:__:__:__:__:[ ]:::::::::::
    !!!!!!!!![ ]!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!![ ]!!!!!!!!!!!
    ^^^^^^^^^[ ]^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^[ ]^^^^^^^^^^^
                [ ]                                        [ ]
                [ ]                                        [ ]
        jgs   [ ]                                        [ ]
        ~~^_~^~/   \~^-~^~ _~^-~_^~-^~_^~~-^~_~^~-~_~-^~_^/   \~^ ~~_ ^
    >>> login
    Username: yourusername
    Password: 
    Authenticating ... 
    Two factor code: 142536
    Adding account ...
    Account yourusername was added successfully.
    >>> list
    ## : account              (status         , address mode   )
    0 : yourusername         (connected      , combined       )
    >>> info
    Configuration for user@domain.com
    IMAP Settings
    Address:   127.0.0.1
    IMAP port: 1143
    Username:  user@domain.com
    Password:  tmWRvK9AIOCwKa7Xw1wEqL
    Security:  STARTTLS
    SMTP Settings
    Address:   127.0.0.1
    SMTP port: 1025
    Username:  user@domain.com
    Password:  tmWRvK9AIOCwKa7Xw1wEqL
    Security:  STARTTLS
    >>> exit

The container will stop itself at the end of this process.

**IMPORTANT:**
In the final info section the bridge gives you the correct username and randomly generated password for connecting other apps to the bridge. 

Bridge will listen on ports 1143 and 1025 for IMAP and SMTP respectively, but the container listens for these services on ports 143 and 25. This is done because bridge expects to only recieve connections from localhost, so we have to spoof that using socat.

## Post Setup

Now that bridge has authenticated with protonmail and you have recorded the randomly generated app password, the container should be removed and re-run normally.

EX

    docker stop protonmail-bridge-container

    docker rm protonmail-bridge-container

    docker run -d --name="protonmail-bridge-container" -v /path/on/host/appdata/proton:/root:rw hluengas/protonmail-bridge:latest

Depending on what type of docker network you use, or if you want to use ports other than 25 an 143, you may need to add port mappings at runtime.

EX

    -p 55525:25 -p 55143:143

By default, the container will run in --noninteractive mode, because it will stop itself after a period of inactivity in --cli mode.

To use CLI mode to manually interact with the bridge use the "INTERACTIVE" environment variable.

EX

    docker stop protonmail-bridge-container

    docker rm protonmail-bridge-container

    docker run -d --name="protonmail-bridge-container" -e INTERACTIVE="true" -v /path/on/host/appdata/proton:/root:rw hluengas/protonmail-bridge:latest