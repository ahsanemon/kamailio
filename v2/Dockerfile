FROM ubuntu:18.04

ENV DBHOST=${DBHOST}
ENV SIP_DOMAIN=${SIP_DOMAIN}
ENV DBROOTUSER=${DBROOTUSER}
ENV DBROOTPASS=${DBROOTPASS}

# Install the required packages
RUN apt-get update && \
    apt-get -y install \
            mysql-client \
            kamailio \
            kamailio-mysql-modules \
    && rm -rf /var/lib/apt/lists/*

# Optional, only for troubleshooting 
RUN apt-get update && \
    apt-get -y install \
            nano \
            ssh \
            tcpdump \
    && rm -rf /var/lib/apt/lists/*
    
# To use MYSQL as DB
RUN sed -i 's/# DBENGINE=MYSQL/DBENGINE=MYSQL/g' /etc/kamailio/kamctlrc && \
    sed -i -e '2i#!define WITH_MYSQL\' /etc/kamailio/kamailio.cfg && \
    sed -i -e '3i#!define WITH_AUTH\' /etc/kamailio/kamailio.cfg && \
    sed -i -e '4i#!define WITH_USRLOCDB\' /etc/kamailio/kamailio.cfg
    
# Changing in DB access parameter
RUN sed -i 's/# DBACCESSHOST=192.168.0.1/DBACCESSHOST=%/g' /etc/kamailio/kamctlrc && \
    sed -i 's/# DBRWUSER="kamailio"/DBRWUSER="kamailio"/g' /etc/kamailio/kamctlrc && \
    sed -i 's/# DBRWPW="kamailiorw"/DBRWPW="kamailiorw"/g' /etc/kamailio/kamctlrc && \
    sed -i 's/# DBROUSER="kamailioro"/DBROUSER="kamailioro"/g' /etc/kamailio/kamctlrc && \
    sed -i 's/# DBROPW="kamailioro"/DBROPW="kamailioro"/g' /etc/kamailio/kamctlrc && \
    sed -i 's/# INSTALL_EXTRA_TABLES=ask/INSTALL_EXTRA_TABLES=yes/g' /etc/kamailio/kamctlrc && \
    sed -i 's/# INSTALL_DBUID_TABLES=ask/INSTALL_DBUID_TABLES=yes/g' /etc/kamailio/kamctlrc && \
    sed -i 's/# INSTALL_PRESENCE_TABLES=ask/INSTALL_PRESENCE_TABLES=yes/g' /etc/kamailio/kamctlrc
    

# To use init.d script for starting/stoping the Kamailio server
RUN sed -i 's/CFGFILE=.*/CFGFILE=\/etc\/kamailio\/kamailio.cfg/g' /etc/init.d/kamailio && \
    sed -i 's/RUN_KAMAILIO=.*/RUN_KAMAILIO=yes/g' /etc/init.d/kamailio && \
    sed -i 's/#RUN_KAMAILIO=yes/RUN_KAMAILIO=yes/g' /etc/default/kamailio && \
    sed -i 's/#CFGFILE=\/etc\/kamailio\/kamailio.cfg/CFGFILE=\/etc\/kamailio\/kamailio.cfg/g' /etc/default/kamailio && \
    sed -i 's/#USER=kamailio/USER=kamailio/g' /etc/default/kamailio && \
    sed -i 's/#GROUP=kamailio/GROUP=kamailio/g' /etc/default/kamailio

# Default setting is to run Kamailio as user “kamailio” and group “kamailio”
RUN mkdir -p /var/run/kamailio && \
    adduser --quiet --system --group --disabled-password --shell /bin/false --gecos "Kamailio" --home /var/run/kamailio kamailio && \
    chown kamailio:kamailio /var/run/kamailio

COPY kamailio-config.sh /
RUN chmod +x /kamailio-config.sh
ENTRYPOINT ["/kamailio-config.sh"]

EXPOSE 5060

# Start the service
CMD ["/etc/init.d/kamailio","start"]
