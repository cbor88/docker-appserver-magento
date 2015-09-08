FROM ubuntu:latest

MAINTAINER David Feller <david.feller@normvarianz.de>

RUN export DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y wget libfreetype6 htop libssl-dev autoconf make libicu-dev build-essential php5-dev

RUN echo "deb http://deb.appserver.io/ wheezy main" > /etc/apt/sources.list.d/appserver.list
RUN wget http://deb.appserver.io/appserver.gpg -O - | apt-key add -

RUN apt-get -y update
RUN apt-get install -y appserver-dist

RUN mkdir -p /opt/appserver/webapps/magento
RUN mkdir -p /opt/appserver/webapps/api/web

VOLUME ["/opt/appserver/var/log","/opt/appserver/webapps","/opt/appserver/etc","/opt/appserver/webapps/magento","/opt/appserver/webapps/api"]

RUN rm /opt/appserver/etc/appserver/conf.d/virtual-hosts.xml

COPY config/virtual-hosts.xml /opt/appserver/etc/appserver/conf.d/virtual-hosts.xml

RUN `which pecl` install intl
RUN echo "extension=intl.so" > /opt/appserver/etc/conf.d/intl.ini

RUN yes "" | `which` pecl install mongo
RUN echo "extension=mongo.so" > /opt/appserver/etc/conf.d/mongo.ini

RUN apt-get purge -y php5-dev
RUN apt-get -y autoremove

COPY scripts/start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 9080
EXPOSE 9443

CMD ["/start.sh"]
