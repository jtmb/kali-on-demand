# syntax=docker/dockerfile:1
FROM kalilinux/kali-last-release:latest


ENV DEBIAN_FRONTEND=noninteractive
ARG USERNAME=${USERNAME}
ENV HOME=/home/${USERNAME}
ARG UID=${UID}
ARG GID=${GID}
ENV TZ=UTC

# Install Common Packages
RUN apt-get update \
      && apt-get install -y --no-install-recommends \
         bash ca-certificates \
         iproute2 iputils-ping \
         tree python3-pip \
         software-properties-common \
         wget unzip curl git net-tools nano gnupg gnupg2 bind9-dnsutils \
         kali-linux-headless\
      && rm -rf /var/lib/apt/lists/*

# Create user and directories
RUN groupadd -g ${GID} ${USERNAME} \
 && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
 && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
 # Create directories
 && mkdir -p /home/${USERNAME}/.ssh \
 && mkdir -p /home/${USERNAME}/.secrets \
 && mkdir -p /home/${USERNAME}/lists \
 && mkdir -p /app \
 # Set ownership
 && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} \
 && chmod 700 /home/${USERNAME}/.ssh /home/${USERNAME}/.secrets \
 && chmod 755 /home/${USERNAME}/repos /home/${USERNAME}/lists /home/${USERNAME} \
 && touch /app/.bashrc \
 && chown ${USERNAME}:${USERNAME} /app/.bashrc
 # Copy custom bashrc
COPY src/bashrc_custom /app/.bashrc
RUN chown ${USERNAME}:${USERNAME} /app/.bashrc
# Symlink .bashrc to your custom one
RUN ln -sf /app/.bashrc /home/${USERNAME}/.bashrc

# Init script
COPY src/docker-init.sh /usr/local/bin/docker-init.sh
RUN chmod +x /usr/local/bin/docker-init.sh

# Switch to user
USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENTRYPOINT ["/usr/local/bin/docker-init.sh"]