#!/bin/bash

# DB IP address
if  [[ !  -z  $DBHOST ]]; then
    printf "\nUpdating DB IP address to...\n"
    sed -i "s/.*DBHOST=.*/DBHOST=$DBHOST/g" /etc/kamailio/kamctlrc
    sed -i "s/#\!define DBURL.*/#\!define DBURL \"mysql:\/\/kamailio:kamailiorw@$DBHOST\/kamailio\"/g" /etc/kamailio/kamailio.cfg
    cat /etc/kamailio/kamctlrc | grep DBHOST=
fi

# DB root access
if  [ !  -z  $DBROOTUSER ] && [ ! -z $DBROOTPASS ]; then
    printf "\nUpdating DB root user and pass...\n"
    sed -i "s/.*DBROOTUSER=.*/DBROOTUSER=$DBROOTUSER \&\& PW=$DBROOTPASS/g" /etc/kamailio/kamctlrc
    cat /etc/kamailio/kamctlrc | grep DBROOTUSER=
fi

# SIP Domain
if  [[ !  -z  $SIP_DOMAIN ]]; then
    printf "\nUpdating SIP Domain to...\n"
    sed -i "s/.*SIP_DOMAIN=.*/SIP_DOMAIN=$SIP_DOMAIN/g" /etc/kamailio/kamctlrc
    cat /etc/kamailio/kamctlrc | grep SIP_DOMAIN=
fi

# Creating kamailio schema in MySQL BD
DATABASE=kamailio
RESULT=`mysql -u$DBROOTUSER -h$DBHOST -p$DBROOTPASS -e "SHOW DATABASES" | grep $DATABASE`
if [ "$RESULT" == "$DATABASE" ]; then
   echo "Database $DATABASE exist ..."
else
   echo "Database $DATABASE does not exist ..."
   echo "Creating Database $DATABASE ..."
   kamdbctl create
   echo "Database $DATABASE created"
fi

#Starting the kamailio service
service kamailio restart

# Adding two test user
kamctl add bob secretpass
kamctl add alice secretpass

exec "$@"
