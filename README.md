# protonmail-bridge
debian docker container for protonmail bridge

# Environment Variables:

SETUP_FILE="/proton_data/first_run.txt"

BRIDGE_VERSION="1.8.9"

# Setup

On first run the container will check for the presence of the SETUP_FILE if not found it will create and setup Pass keyring.


# Docker CLI Example:

docker run -d --name=protonmail-bridge -v appdata/protonmail-bridge:/root:rw --restart=unless-stopped hluengas/protonmail-bridge:latest