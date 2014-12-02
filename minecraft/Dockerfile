FROM zargony/base

RUN apt-get -qqy install default-jre-headless

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 97BDD17642A97E9B43E7FF23AB6EAF871F4C1BCE
RUN echo "deb http://overviewer.org/debian ./" >/etc/apt/sources.list.d/overviewer.list
RUN apt-get -qq update
RUN apt-get -qqy install minecraft-overviewer

ADD https://s3.amazonaws.com/Minecraft.Download/versions/1.7.10/1.7.10.jar /opt/minecraft/minecraft.jar
ADD https://s3.amazonaws.com/Minecraft.Download/versions/1.7.10/minecraft_server.1.7.10.jar /opt/minecraft/minecraft_server.jar
RUN chmod 644 /opt/minecraft/minecraft*.jar

RUN useradd -d /opt/minecraft -s /bin/bash -u 1280 -g 100 -c Minecraft minecraft

VOLUME ["/var/lib/minecraft"]

WORKDIR /var/lib/minecraft
USER minecraft
CMD ["/usr/bin/java", "-Xmx1024M", "-Xms1024M", "-jar", "/opt/minecraft/minecraft_server.jar", "nogui"]
EXPOSE 25565
