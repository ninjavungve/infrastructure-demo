FROM zargony/base

RUN apt-get -qqy install default-jre-headless

ADD https://s3.amazonaws.com/Minecraft.Download/versions/1.7.10/minecraft_server.1.7.10.jar /opt/minecraft/minecraft_server.jar
RUN chmod 644 /opt/minecraft/minecraft_server.jar

RUN useradd -d /opt/minecraft -s /bin/bash -u 1280 -g 100 -c Minecraft minecraft

VOLUME ["/var/lib/minecraft"]

WORKDIR /var/lib/minecraft
USER minecraft
CMD ["/usr/bin/java", "-Xmx1024M", "-Xms1024M", "-jar", "/opt/minecraft/minecraft_server.jar", "nogui"]
EXPOSE 25565
