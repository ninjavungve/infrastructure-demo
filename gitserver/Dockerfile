FROM zargony/base

ADD ssh_host_dsa_key /etc/ssh/
ADD ssh_host_dsa_key.pub /etc/ssh/
ADD ssh_host_ecdsa_key /etc/ssh/
ADD ssh_host_ecdsa_key.pub /etc/ssh/
ADD ssh_host_rsa_key /etc/ssh/
ADD ssh_host_rsa_key.pub /etc/ssh/
RUN chown 0:0 /etc/ssh/ssh_host*key*; chmod 600 /etc/ssh/ssh_host*key; chmod 644 /etc/ssh/ssh_host*key.pub
RUN mkdir /var/run/sshd

RUN apt-get -qqy install openssh-server git-core

RUN useradd -d /var/git/zargony -s /usr/bin/git-shell -u 1224 -g 100 zargony
RUN useradd -d /var/git/mira -s /usr/bin/git-shell -u 1233 -g 100 mira
RUN useradd -d /var/git/hws -s /usr/bin/git-shell -u 1260 -g 100 hws

VOLUME ["/var/git"]

CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 22
