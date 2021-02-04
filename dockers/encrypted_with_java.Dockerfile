FROM registry.gitlab.com/cprevosteau/installation/encrypted
RUN sudo apt-get update && sudo apt-get install -y openjdk-13-jre-headless \
            && \
            # Housekeeping
            apt-get clean -y &&                                          \
            rm -rf                                                       \
               /var/cache/debconf/*                                           \
               /var/lib/apt/lists/*                                           \
               /var/log/*                                                     \
               /tmp/*                                                         \
               /var/tmp/*                                                     \
               /usr/share/doc/*                                               \
               /usr/share/man/*                                               \
               /usr/share/local/* || true
