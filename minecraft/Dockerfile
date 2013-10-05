FROM zargony/base

RUN apt-get -qqy install default-jre-headless

#ADD https://s3.amazonaws.com/Minecraft.Download/versions/1.6.2/minecraft_server.1.6.2.jar /opt/minecraft/

VOLUME ["/opt/minecraft"]

WORKDIR /opt/minecraft
CMD ["/usr/bin/java", "-Xmx1024M", "-Xms1024M", "-jar", "minecraft_server.jar", "nogui"]
EXPOSE 25565
