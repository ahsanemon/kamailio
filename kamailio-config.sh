#!/bin/bash 
  
# DB IP address
if  [[ !  -z  $DBHOST ]]; then 
    printf "\nChanging DB IP address ...\n" 
    sed -i "s/# DBHOST=localhost/DBHOST=$DBHOST/g" /usr/local/etc/kamailio/kamctlrc 
    cat /usr/local/etc/kamailio/kamctlrc | grep DBHOST= 
fi 

exec "$@" 
