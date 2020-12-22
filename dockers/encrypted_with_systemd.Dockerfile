# Sample container image with Ubuntu Focal + Systemd
#
# Description:
#
# This image serves as a basic reference example for user's looking to
# run Systemd inside a system container in order to deploy various
# services within the system container, or use it as a virtual host
# environment.
#
# Usage:
#
# $ docker run --runtime=sysbox-runc -it --rm --name=syscont nestybox/ubuntu-focal-systemd
#
# This will run systemd and prompt for a user login; the default user/password
# in this image is "admin/admin".

FROM encrypted:latest

#
# Systemd installation
#
USER root
RUN    apt-get update && \
    apt-get install -y --no-install-recommends   \
            systemd                              \
            systemd-sysv                         \
            libsystemd0                          \
            ca-certificates                      \
            dbus                                 \
            iptables                             \
            iproute2                             \
            jq                                   \
            kmod                                 \
            locales                              \
            udev &&                              \
                                                 \
    # Prevents journald from reading kernel messages from /dev/kmsg
    echo "ReadKMsg=no" >> /etc/systemd/journald.conf &&                 \
                                                                      \
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
       /usr/share/local/*

# Make use of stopsignal (instead of sigterm) to stop systemd containers.
STOPSIGNAL SIGRTMIN+3

RUN echo "clement:clement" | chpasswd
# Set systemd as entrypoint.
ENTRYPOINT ["/sbin/init", "--log-level=err"]
COPY . $TESTS_DIR/../