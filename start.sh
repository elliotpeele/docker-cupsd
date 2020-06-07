#!/bin/bash -xe
#
# Copyright (c) Elliot Peele <elliot@bentlogic.net>
#

# Copy config files to volume if mounted
if [ ! -e /etc/cups/cupsd.conf ] ; then
    cp -rvf /etc/cups.orig/* /etc/cups/
fi

/usr/sbin/cupsd -f
