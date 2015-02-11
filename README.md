#Appserver im Docker-Container

Basis-Container zum Betrieb des [Appservers](http://www.appserver.io) als Webserver.

##Voraussetzungen
* Docker >= v1.1
* (Mac) Boot2Docker 

Wird Ubuntu 12.04 bzw. 14.04 als Host verwendet, sollten *nicht* die mitgelieferten Pakete, sondern das aktuelle Repository von Docker selbst verwendet werden. Docker stellt dazu ein eigenes Script zur Verfügung:

    sudo apt-get purge docker.io
    curl -s https://get.docker.io/ubuntu/ | sudo sh
    sudo apt-get update
    sudo apt-get install lxc-docker
    
Unter Fedora bzw. RHEL/CentOS kann es zu Problemen mit selinux kommen. Aus diesem Grund sollte möglichst selinux mittels ```setenforce 0``` deaktiviert werden. Allerdings wird dies von RedHat auf Produktivsystemen ausdrücklich *nicht* empfohlen.

## Für Eilige... einfach los!
Wer einfach nur einen Appserver-Container vom DockerHub ziehen und unverändert starten möchte, kann dies ganz wie folgt tun:

	docker run -d --name 'appserver.io' -p 9080:9080 davidfeller/appserver.io

##<small>für alle anderen...</small> Installation und Bau des Containers
Aktuell befinden sich noch keine fertigen Images im DockerHub, sodass ein eigenes Image gebaut werden muss

    git clone https://github.com/DavidFeller/docker-appserver.git
    cd docker-appserver
    docker build -t "$USER/appserver" .

##Volumes und Ports
Als DocumentRoot kann ein lokales Verzeichnis, z.B. ```/var/www``` in ```/opt/appserver/webapps``` eingebunden werden. Zudem werden zu Wartungszwecken die Verzeichnisse ```/opt/appserver/etc``` und ```/opt/appserver/var``` als Volumes deklariert, sodass sie später von anderen Docker-Container eingebunden und ggf. editiert werden können.

Damit der Container von außen erreichbar ist, werden die Ports 9080 und 9443 "exposed".

##Start des Containers
Da Docker nur bedingt mit Upstart-Skripten umgehen kann, muss der Appserver beim Start des Containers mittels eines Bash-Skripts gestartet werden. Dazu wird beim Start des Containers die Datei ```start.sh``` eingebunden und ausgeführt.

```docker run -d --name 'appserver' -p 9080:9080 -p 9443:9443 -v /var/www:/opt/appserver/webapps $USER/appserver```

##Demo
[http://docker.browse-technology.com:9081/](http://docker.browse-technology.com:9081/)
