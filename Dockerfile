FROM phusion/baseimage:bionic-1.0.0

# Use baseimage-docker's init system:
CMD ["/sbin/my_init"]

# Install dependencies:
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    sudo \
    wget \
    zip \
    unzip \
    nmap \
    golang \
    perl \
    ruby-full \
    clang \
    wget \
    aria2 \
    trace* \
    apache2 \
    openssh-server \
    netcat \
    tor \
    python3 \
    python3-pip \
    git \
    make \
    busybox \
    build-essential \
    nodejs \
    npm \
 && mkdir -p -vv /stuff

# Brew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Set work dir:
WORKDIR /home

# Copy files:
COPY startbot.sh /home/
COPY startup.sh /home/
COPY extras.sh /home/
COPY /stuff /stuff

# Run extras.sh and clean up APT:
RUN sh /home/extras.sh \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the bot:
RUN git clone https://github.com/botgram/shell-bot.git \
 && cd shell-bot \
 && npm install

# Run bot script:
CMD bash /home/startbot.sh
