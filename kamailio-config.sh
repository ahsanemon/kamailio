#!/bin/bash 
  
# DB IP address
if  [[ !  -z  $DBHOST ]]; then 
    printf "\nUpdating DB IP address to...\n" 
    sed -i "s/.*DBHOST=.*/DBHOST=$DBHOST/g" /usr/local/etc/kamailio/kamctlrc 
    cat /usr/local/etc/kamailio/kamctlrc | grep DBHOST= 
fi 

# DB root access
if  [[ !  -z  $DBROOTUSER -a ! -z $DBROOTPASS ]]; then 
    printf "\nUpdating DB root user and pass...\n" 
    sed -i 's/.*DBROOTUSER=.*/DBROOTUSER="$DBROOTUSER" \&\& PW="$DBROOTPASS"/g' /usr/local/etc/kamailio/kamctlrc
    cat /usr/local/etc/kamailio/kamctlrc | grep DBROOTUSER= 
fi 

# SIP Domain
if  [[ !  -z  $SIP_DOMAIN ]]; then 
    printf "\nUpdating SIP Domain to...\n" 
    sed -i "s/.*SIP_DOMAIN=.*/SIP_DOMAIN=$SIP_DOMAIN/g" /usr/local/etc/kamailio/kamctlrc 
    cat /usr/local/etc/kamailio/kamctlrc | grep SIP_DOMAIN= 
fi

exec "$@" 
