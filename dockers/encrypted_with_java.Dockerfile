FROM registry.gitlab.com/cprevosteau/installation/encrypted
RUN sudo apt-get update && sudo apt-get install -y openjdk-13-jre-headless
