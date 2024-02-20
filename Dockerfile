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

# Download Python 3.12 source code
WORKDIR /usr/src
RUN wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz && \
    tar -xf Python-3.12.0.tgz && \
    rm Python-3.12.0.tgz

# Compile and install Python 3.12
WORKDIR /usr/src/Python-3.12.0
RUN ./configure --enable-optimizations && \
    make -j $(nproc) && \
    make install

# Clean up
WORKDIR /usr/src
RUN rm -rf Python-3.12.0

# Install pip
RUN python3.12 -m ensurepip --upgrade

# Install Python dependencies
COPY build/requirements.txt /tmp/requirements.txt
RUN python3.12 -m pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Expose the SSH and JupyterLab ports
EXPOSE 22
EXPOSE 8888

# Start SSH and JupyterLab services
COPY build/startup.sh /root/startup.sh
COPY build/secrets.env /root/secrets.env
RUN chmod +x /root/startup.sh
CMD ["/bin/sh", "-c", "/root/startup.sh && tail -f /dev/null"]