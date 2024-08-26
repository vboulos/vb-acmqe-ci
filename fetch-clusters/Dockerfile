# Build image
# docker build --platform linux/amd64 -t quay.io/vboulos/acmqe-automation/fetch-clusters:fetch-v.1.0 -f fetch-clusters/Dockerfile .

FROM python:latest

# Install oc/yq
RUN curl -fksSL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz | tar -xvz -C /usr/local/bin/ oc
RUN wget https://github.com/mikefarah/yq/releases/download/v4.13.2/yq_linux_amd64 -O /usr/local/bin/yq && chmod +x /usr/local/bin/yq
RUN apt update && apt install jq -y

# Copy fetch managed cluster script into /tmp/ci folder
RUN mkdir /tmp/ci
WORKDIR /tmp/ci
COPY . .  
RUN chmod +x fetch-clusters/fetch_clusters_commands.sh

# Set required permissions for OpenShift usage
RUN chgrp -R 0 /tmp && \
    chmod -R g=u /tmp

CMD ["/bin/bash"]
