FROM debian

ENV MATTERMOST_VERSION 3.5.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends locales ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ADD https://releases.mattermost.com/${MATTERMOST_VERSION}/mattermost-team-${MATTERMOST_VERSION}-linux-amd64.tar.gz /tmp/mattermost.tar.gz
RUN tar -C / -zxf /tmp/mattermost.tar.gz --no-same-owner && \
    rm -f /mattermost.tar.gz

COPY config.json /mattermost/config/

VOLUME /mattermost/data

COPY run.sh /
RUN chmod 755 /run.sh
ENTRYPOINT ["/run.sh"]

EXPOSE 8065
