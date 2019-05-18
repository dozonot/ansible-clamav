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

# exclude setup
EXCLUDECONF=/root/clamscan-exclude.conf
if [ -s $EXCLUDECONF ]; then
    for i in `cat $EXCLUDECONF`
    do
        if [ $(echo "$i"|grep \/$) ]; then
            i=`echo $i|sed -e 's/^\([^ ]*\)\/$/\1/p' -e d`
            EXCLUDE="${EXCLUDE} --exclude-dir=^$i"
        else
            EXCLUDE="${EXCLUDE} --exclude=^$i"
        fi
    done
fi

# virus scan
CLAMSCANTMP=`mktemp`
clamdscan --recursive --move=/tmp ${EXCLUDE} / > $CLAMSCANTMP 2>&1
[ ! -z "$(grep FOUND$ $CLAMSCANTMP)" ] && \
rm -f $CLAMSCANTMP
