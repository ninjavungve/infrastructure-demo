FROM debian

RUN apt-get update && \
    apt-get install -y --no-install-recommends locales ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV MATTERMOST_VERSION 4.1.0

ADD https://releases.mattermost.com/${MATTERMOST_VERSION}/mattermost-${MATTERMOST_VERSION}-linux-amd64.tar.gz /tmp/
RUN tar -C /opt -zxf /tmp/mattermost-${MATTERMOST_VERSION}-linux-amd64.tar.gz --no-same-owner && \
    rm -f /tmp/mattermost-${MATTERMOST_VERSION}-linux-amd64.tar.gz && \
    addgroup --gid 1000 mattermost && \
    adduser --no-create-home --uid 1000 --gid 1000 --disabled-password mattermost && \
    install -d -o mattermost -g mattermost -m 0755 /opt/mattermost/data && \
    chown -R mattermost:mattermost /opt/mattermost/config
USER mattermost
WORKDIR /opt/mattermost

VOLUME /opt/mattermost/data

CMD ["/opt/mattermost/bin/platform"]
EXPOSE 8065
