FROM ubuntu:latest

MAINTAINER David Feller <contact@david-feller.com>

RUN export DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y wget libfreetype6
RUN echo "deb http://deb.appserver.io/ wheezy main" > /etc/apt/sources.list.d/appserver.list
RUN wget http://deb.appserver.io/appserver.gpg -O - | apt-key add -

RUN apt-get -y update
RUN apt-get install -y appserver-dist
RUN mkdir -p /opt/appserver/webapps/magento

VOLUME ["/opt/appserver/etc", "/opt/appserver/var", "/opt/appserver/webapps/magento"]

RUN rm /opt/appserver/etc/appserver/appserver.xml
RUN rm /opt/appserver/etc/appserver/conf.d/virtual-hosts.xml

COPY config/appserver.xml /opt/appserver/etc/appserver/appserver.xml
COPY config/virtual-hosts.xml /opt/appserver/etc/appserver/conf.d/virtual-hosts.xml

COPY scripts/start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 9080
EXPOSE 9443

CMD ["/start.sh"]
