FROM ubuntu:latest

MAINTAINER rjerrom@vmware.com
LABEL authors="rjerrom@vmware.com"

ENV TERM linux

#give envvar GOVVC_INSECURE a default of 1 (true) - override for production to verify cert.
ARG GOVC_INSECURE=1
ENV GOVC_INSECURE $GOVC_INSECURE

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

# Grab the latest govmomi release and set it up.
RUN curl -L $(curl -s https://api.github.com/repos/vmware/govmomi/releases/latest | grep browser_download_url | grep govc_linux_amd64 | cut -d '"' -f 4) | gunzip > /usr/local/bin/govc && \
    chmod +x /usr/local/bin/govc

# Clean up APT when done.
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /scripts
COPY vsphere-cns-roles-setup.sh /scripts

ENTRYPOINT ["/bin/bash", "/scripts/vsphere-cns-roles-setup.sh"]
