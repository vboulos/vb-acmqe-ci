
# CentOS Stream 9 with Nodejs18
# docker build --platform linux/amd64 --build-arg GITHUB_TOKEN=value --build-arg GITHUB_USER=value GIT_BRANCH=value -t quay.io/vboulos/acmqe-automation/clc:release-2.10 -f clc-ui/Dockerfile .


FROM quay.io/centos/centos:stream9

# Set environment variable for the GitHub token
# ENV GITHUB_TOKEN ${GITHUB_TOKEN}
# ENV GITHUB_USER ${GITHUB_USER}
# ENV GIT_BRANCH ${GIT_BRANCH}

ARG GITHUB_TOKEN
ARG GITHUB_USER
ARG GIT_BRANCH

# USER root
ARG NODE=nodejs:18
ARG CHROME=https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
ARG FIREFOX=https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US
ARG OCP_CLI=https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz
ARG GConf2=https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64/Packages/g/GConf2-3.2.6-34.el9.x86_64.rpm
ARG YQ=https://github.com/mikefarah/yq/releases/download/v4.30.8/yq_linux_amd64
# ARG AWS_CLI=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
# ARG ROSA_CLI=https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/rosa/latest/rosa-linux.tar.gz

# Install required packages
RUN dnf install -y \
    httpd-tools \
    wget \
    bzip2 \
    jq \
    git \
    kernel-headers \
    python3.9 \
    'dnf-command(config-manager)' \
    xorg-x11-server-Xvfb \
    gtk2-devel \
    gtk3-devel \
    libnotify-devel \
    nss \
    libXScrnSaver \
    alsa-lib \
    gcc \
    gcc-c++ \
    make
   # GConf2

# Install GConf2
RUN dnf install -y "$GConf2"

# Install oc@latest
RUN curl -fksSL "$OCP_CLI" | tar -xvz -C /usr/local/bin/ oc kubectl

# Install yq@4.30.8
RUN wget "$YQ" -O /usr/local/bin/yq && chmod +x /usr/local/bin/yq

# Install AWS_CLI
# RUN curl "$AWS_CLI" -o aws.zip && unzip aws.zip && ./aws/install && rm -rf aws*

# Install ROSA_CLI
# RUN wget -qO- "$ROSA_CLI" | tar zxv -C /usr/local/bin/ rosa

# Install latest kubectl
# RUN curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
# RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install and enable docker    
# USER root
# RUN dnf install -y epel-release -y \
# && dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
# && dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# Install NodeJs
RUN dnf module enable -y "$NODE" \
    && dnf module install -y "$NODE"/common

# Install Google Chrome
RUN dnf install -y "$CHROME"

# Install Microsoft Edge
# RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc \
#     && dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge \
#     && mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge.repo \
#     && dnf install microsoft-edge-stable -y

# Install Mozilla Firefox
RUN wget -O- "$FIREFOX" | tar -jx -C /usr/local \
    && ln -s /usr/local/firefox/firefox /usr/bin/firefox

# Remove installed files that are no longer needed    
RUN dnf clean all


# Copy the CLC repo repo into /tmp/clc folder
RUN mkdir /tmp/clc
WORKDIR /tmp/clc
RUN git clone -b ${GIT_BRANCH} https://oauth2:${GITHUB_TOKEN}@github.com/stolostron/clc-ui-e2e.git "$GIT_BRANCH"
RUN ls -al
WORKDIR /tmp/clc/${GIT_BRANCH}

# point Cypress at the /tmp/cache no matter what user account is used
# see https://on.cypress.io/caching
ENV CYPRESS_CACHE_FOLDER=/tmp/.cache/Cypress

# Install node packages and update browsers list
# RUN npm config set unsafe-perm true \
RUN npm config set loglevel warn \
    && npm install -g\
    && npm ci \
    && npx browserslist@latest --update-db

RUN npx cypress cache path
RUN npx cypress cache list

RUN echo  "node version:    $(node -v) \n" \
    "npm version:     $(npm -v) \n" \
    "user:            $(whoami) \n" \
    "chrome:          $(google-chrome --version || true) \n" \
    "firefox:         $(firefox --version || true) \n"    

# Set required permissions for OpenShift usage
RUN chgrp -R 0 /tmp && \
    chmod -R g=u /tmp

RUN mkdir -p /.config
RUN chgrp -R 0 /.config && \
    chmod -R g=u /.config

# good colors for most applications
ENV TERM=xterm


CMD ["/bin/bash"]


