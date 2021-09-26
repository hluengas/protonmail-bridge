FROM debian:latest

ENV BRIDGE_VERSION="1.8.9"

RUN apt-get update && apt-get install -y \
    debsig-verify \
    debian-keyring \
    pass \
    curl

RUN curl -o protonmail_bridge.deb https://protonmail.com/download/bridge/protonmail-bridge_${BRIDGE_VERSION}-1_amd64.deb && \
    curl -o bridge_pubkey.gpg https://protonmail.com/download/bridge_pubkey.gpg && \
    curl -o bridge.pol https://protonmail.com/download/bridge.pol

RUN gpg --dearmor --output debsig.gpg bridge_pubkey.gpg && \
    mkdir -p /usr/share/debsig/keyrings/E2C75D68E6234B07 && \
    mv debsig.gpg /usr/share/debsig/keyrings/E2C75D68E6234B07

RUN mkdir -p /etc/debsig/policies/E2C75D68E6234B07 && \
    cp bridge.pol /etc/debsig/policies/E2C75D68E6234B07

RUN debsig-verify protonmail_bridge.deb

RUN apt-get install -y ./protonmail_bridge.deb

# CMD Desktop-Bridge --cli
CMD /bin/bash