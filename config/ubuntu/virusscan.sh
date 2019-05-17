#!/bin/sh

# exclude setup
EXCLUDECONF=/etc/clamav/clamscan-exclude.conf
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

# report mail send
grep FOUND$ $CLAMSCANTMP | mail -s "Virus Found in `hostname`" root
rm -f $CLAMSCANTMP
