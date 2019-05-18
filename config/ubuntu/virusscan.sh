#!/bin/sh

# virus scan
CLAMSCANTMP=`mktemp`
clamdscan --recursive --move=/tmp ${EXCLUDE} / > $CLAMSCANTMP 2>&1
[ ! -z "$(grep FOUND$ $CLAMSCANTMP)" ] && \
rm -f $CLAMSCANTMP
