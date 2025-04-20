# Use Ubuntu latest image as the base
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Copy package list and install necessary dependencies
COPY build/packages.txt /tmp/packages.txt
RUN apt-get clean && \
    apt-get update && \
    xargs -a /tmp/packages.txt apt-get install -y && \
    rm /tmp/packages.txt && \
    rm -rf /var/lib/apt/lists/*

# Install Golang
RUN apt-get update && apt-get install -y golang-go


# Expose the SSH ports
EXPOSE 22

# Start SSH and JupyterLab services
COPY build/startup.sh /root/startup.sh
COPY build/secrets.env /root/secrets.env
RUN chmod +x /root/startup.sh
CMD ["/bin/sh", "-c", "/root/startup.sh && tail -f /dev/null"]