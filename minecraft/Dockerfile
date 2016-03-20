FROM java:8-jre

ENV MINECRAFT_VERSION=1.8.8

ADD https://s3.amazonaws.com/Minecraft.Download/versions/$MINECRAFT_VERSION/$MINECRAFT_VERSION.jar /opt/minecraft/minecraft.jar
ADD https://s3.amazonaws.com/Minecraft.Download/versions/$MINECRAFT_VERSION/minecraft_server.$MINECRAFT_VERSION.jar /opt/minecraft/minecraft_server.jar
RUN chmod 644 /opt/minecraft/minecraft*.jar

RUN useradd -d /opt/minecraft -s /bin/bash -u 1280 -g 100 -c Minecraft minecraft

VOLUME /var/lib/minecraft

WORKDIR /var/lib/minecraft
USER minecraft
CMD ["/usr/bin/java", "-Xmx1024M", "-Xms1024M", "-jar", "/opt/minecraft/minecraft_server.jar", "nogui"]
EXPOSE 25565
