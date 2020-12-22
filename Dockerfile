FROM ubuntu:20.04
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
    apt-get update && apt-get install -y bats gettext-base git jq rsync sudo tzdata wget
ARG USER
ENV USER=$USER
RUN useradd -ms /bin/bash $USER &&\
    usermod -aG sudo $USER &&\
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $USER
# Make required env directories
ENV ENV_REQUIRED=".env_required"
ENV HOME="/home/$USER"
COPY env/$ENV_REQUIRED .
RUN set -a; . "./$ENV_REQUIRED"; set +a &&\
    envsubst <"$ENV_REQUIRED" | grep _DIR | sed -e "s/.*=//" | xargs -L 2 mkdir -p &&\
    sudo rm "$ENV_REQUIRED"
ARG TESTS_DIR
ENV TESTS_DIR=$TESTS_DIR
WORKDIR $HOME
COPY dockers/entrypoint.sh entrypoint.sh
ENTRYPOINT ["sh", "entrypoint.sh"]
CMD bats -r "${TESTS_DIR}/src"