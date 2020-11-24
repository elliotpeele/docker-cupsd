# Copyright (c) Elliot Peele <elliot@bentlogic.net>

# Cups Daemon Container Image
FROM fedora:32

ARG adminpassword=cupsadm

LABEL maintainer="Elliot Peele <elliot@bentlogic.net>"

RUN dnf update -y && dnf install -y cups hplip mkpasswd usbutils

COPY start.sh /

# Add a user that has access to login to the cups web ui
RUN useradd \
  --groups=lp,wheel \
  --create-home \
  --home-dir=/var/lib/cupsadm \
  --shell=/bin/bash \
  --password=$(mkpasswd $adminpassword) \
  cupsadm

# Reconfigure CUPS to share by default and enable debug logging
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers --user-cancel-any --debug-logging \
  && kill $(cat /var/run/cups/cupsd.pid)

# Reconfigure logging to go to stderr
RUN cp /etc/cups/cups-files.conf /etc/cups/cups-files.conf.orig \
  && sed \
    -e 's|^AccessLog.*|AccessLog stderr|' \
    -e 's|^ErrorLog.*|ErrorLog stderr|' \
    -e 's|^PageLog.*|PageLog stderr|' \
    /etc/cups/cups-files.conf.orig > /etc/cups/cups-files.conf

# Disable requirement for TLS
RUN sed -i '/^DefaultAuthType.*/i DefaultEncryption IfRequested' /etc/cups/cupsd.conf

# Make backup of configuration directory to populate potential volume
RUN cp -rf /etc/cups /etc/cups.orig

CMD ["/start.sh"]
