FROM ubuntu:20.04
RUN apt-get update && apt-get install -y git sudo bats gettext-base
ARG USER
ENV USER=$USER
RUN useradd -ms /bin/bash $USER &&\
    usermod -aG sudo $USER &&\
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $USER
WORKDIR /home/$USER
# Make required env directories
ENV ENV_REQUIRED=".env_required"
ENV HOME="/home/$USER"
COPY env/$ENV_REQUIRED .
RUN set -a; . "./$ENV_REQUIRED"; set +a &&\
    envsubst <"$ENV_REQUIRED" | grep _DIR | sed -e "s/.*=//" | xargs -L 2 mkdir -p &&\
    sudo rm "$ENV_REQUIRED"