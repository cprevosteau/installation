FROM ubuntu:20.04
RUN apt-get update && apt-get install -y git sudo
RUN git clone https://github.com/bats-core/bats-core.git
ENV PATH="/bats-core/bin:$PATH"
ARG USER
ENV USER=$USER
RUN useradd -ms /bin/bash $USER &&\
    usermod -aG sudo $USER &&\
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $USER
WORKDIR /home/$USER