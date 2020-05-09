# Dockerfile References: https://docs.docker.com/engine/reference/builder/

# Start from the latest golang base image
FROM golang:1.14.2

# Add Maintainer Info
LABEL maintainer="Steve Orens <steve@orens.com>"

# install basic linux tools
RUN ["apt-get", "update"]
RUN ["apt-get", "-y", "install", "vim"]
RUN ["apt-get", "-y", "install", "tree"]
RUN ["apt-get", "-y", "install", "jq"]

# copy pre-built linux binaries to the container
COPY build/linux/* /usr/local/bin/

# Command to run the executable
ENTRYPOINT ["/usr/local/bin/hello"]
