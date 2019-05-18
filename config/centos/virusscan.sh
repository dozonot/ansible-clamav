#!/bin/sh

# Update pattern file.
LOG_FILE="/var/log/freshclam.log"
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"
fi

/usr/bin/freshclam \
    --quiet \
    --datadir="/var/lib/clamav" \
    --log="$LOG_FILE"

# virus scan
CLAMSCANTMP=`mktemp`
clamdscan --recursive --move=/tmp ${EXCLUDE} / > $CLAMSCANTMP 2>&1
[ ! -z "$(grep FOUND$ $CLAMSCANTMP)" ] && \
rm -f $CLAMSCANTMP
