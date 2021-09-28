# GoLang Build Image
FROM golang:latest AS build

# Version Variable
ENV SETUP_FILE="/protonmail/first_run.txt"
ENV BRIDGE_VERSION="1.8.9"

# Install Build Dependencies
RUN apt-get update && \
    apt-get install -y libsecret-1-dev

# Build Source
WORKDIR /build/
RUN git clone https://github.com/ProtonMail/proton-bridge.git && \
    cd proton-bridge && \
    git checkout v${BRIDGE_VERSION} && \
    make build-nogui

# Debian Base Image
FROM debian:latest

# Install dependencies
# Install dependencies and protonmail bridge
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    pass \
    libsecret-1-0

# Copy scripts
COPY gpgparams entrypoint.sh /protonmail/

# Copy Binary From Build Stage
COPY --from=build /build/proton-bridge/proton-bridge /protonmail/

EXPOSE 1025
EXPOSE 1143

# Start Protonmail-Bridge
ENTRYPOINT ["bash", "/protonmail/entrypoint.sh"]
