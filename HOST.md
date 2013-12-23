# Setting up a real host

Assuming that a the real host has two hard drives that should be mirrored. First, start a rescue system from an external media.

## Create and mount root filesystem

### Option 1: MDADM and LVM

    $ fdisk /dev/sda      # create a single primary partition of type FD (Linux RAID autodetect))
    $ fdisk /dev/sdb      # ditto
    $ mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
    $ pvcreate /dev/md0
    $ vgcreate vg0 /dev/md0
    $ lvcreate -L 2G -n server_root vg0
    $ lvcreate -L 1G -n server_swap vg0
    $ mkfs.ext4 /dev/vg0/server_root
    $ mkswap -c /dev/vg0/server_swap
    $ mkdir /mnt/server
    $ mount /dev/vg0/server_root /mnt/server

### Option 2: BTRFS

    $ mkfs.btrfs /dev/sda /dev/sdb
    $ mkdir /mnt/server
    $ mount /dev/sda /mnt/server

## Install base system

    $ wget http://raw.github.com/zargony/infrastructure/master/bootstrap.sh
    $ . ./bootstrap.sh -b /mnt/server

## Configuration

*etc/mdadm/mdadm.conf*

    #DEVICE partitions containers
    CREATE owner=root group=disk mode=0660 auto=yes
    HOMEHOST <system>
    MAILADDR root
    ARRAY /dev/md/0 metadata=1.2 UUID=xxxxxxxx:xxxxxxxx:xxxxxxxx:xxxxxxxx name=server:0

*etc/fstab*

    # <file system> <mount point> <type> <options> <dump> <pass>
    proc                                      /proc proc  defaults                  0 0
    sys                                       /sys  sysfs defaults                  0 0
    UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /     ext4  noatime,errors=remount-ro 0 1
    UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx none  swap  sw                        0 0

*etc/hostname*

    server

*etc/network/interfaces* (Hetzner host routing)

    auto lo eth0
    iface lo inet loopback
    iface eth0 inet static
      address xx.xx.xx.xx
      netmask 255.255.255.255
      gateway xx.xx.xx.xx
      pointopoint xx.xx.xx.xx
    iface eth0 inet6 static
      address xxxx:xxx:xxx:xxx::2
      netmask 64
      gateway fe80::1

*etc/resolv.conf* (Hetzner DNS)

    domain dc.zargony.com
    nameserver 213.133.98.98
    nameserver 213.133.99.99
    nameserver 213.133.100.100
    nameserver 2a01:4f8:0:a0a1::add:1010
    nameserver 2a01:4f8:0:a102::add:9999
    nameserver 2a01:4f8:0:a111::add:9898

## Bootloader

Add `panic=60` to the kernel commandline to ensure a reboot after a kernel panic.

*etc/default/grub*

    GRUB_DEFAULT=0
    GRUB_HIDDEN_TIMEOUT=0
    GRUB_HIDDEN_TIMEOUT_QUIET=true
    GRUB_TIMEOUT=10
    GRUB_CMDLINE_LINUX_DEFAULT=""
    GRUB_CMDLINE_LINUX="panic=60"

Install the bootloader to both harddisks.

    $ mount -t proc none /mnt/server/proc
    $ mount -o bind /dev /mnt/server/dev
    $ chroot /mnt/server /usr/sbin/grub-install /dev/sda
    $ chroot /mnt/server /usr/sbin/grub-install /dev/sdb
    $ chroot /mnt/server /usr/sbin/update-grub2

## Restart

    $ umount /mnt/server/dev
    $ umount /mnt/server/proc
    $ umount /mnt/server
    $ sync
    $ reboot

## Useful services

### Relay Mailer

    $ aptitude install ssmtp

*etc/ssmtp/ssmtp.conf*

    root=xxx@xxx.com
    mailhub=mail02.dd24.net
    hostname=server.dc.zargony.com

### Monitoring

    $ aptitude install monit

*etc/monit/monitrc*

    set daemon 60 with start delay 30

    set logfile /var/log/monit.log
    set idfile /var/lib/monit/id
    set statefile /var/lib/monit/state
    set eventqueue basedir /var/lib/monit/events slots 100

    set mailserver mail02.dd24.net
    set mail-format {
      from: monit@$HOST
      subject: ALERT: $SERVICE $DESCRIPTION
      message: Event:  $SERVICE $DESCRIPTION
    Action: $ACTION
    Host:   $HOST
    Date:   $DATE
    }
    set alert xxx@xxx.com not on { instance }

    set httpd port 2812 and use address localhost allow localhost only

    check system xxx
      if loadavg (1min) > 5 then alert
      if loadavg (5min) > 3 then alert
      if memory usage > 95% for 5 cycles then alert
      if swap usage > 50% for 5 cycles then alert
      if cpu usage (user) > 90% for 5 cycles then alert
      if cpu usage (system) > 50% for 5 cycles then alert
      if cpu usage (wait) > 40% for 5 cycles then alert

    check process sshd with pidfile /run/sshd.pid
      start program = "/sbin/start ssh"
      stop program = "/sbin/stop ssh"
      if failed host localhost port 22 type tcp protocol ssh then restart

    check filesystem rootfs with path /
      if space usage > 90% for 2 cycles then alert
      if inode usage > 90% for 2 cycles then alert

    check filesystem dockerfs with path /var/lib/docker
      if space usage > 90% for 2 cycles then alert
      if inode usage > 90% for 2 cycles then alert

    include /etc/monit/conf.d/*.monitrc

### Firewall

    $ aptitude install ufw
    $ ufw allow OpenSSH

*etc/default/ufw*

    IPV6=yes
    DEFAULT_INPUT_POLICY="DROP"
    DEFAULT_OUTPUT_POLICY="ACCEPT"
    DEFAULT_FORWARD_POLICY="DROP"
    DEFAULT_APPLICATION_POLICY="SKIP"
    MANAGE_BUILTINS=no

*etc/ufw/ufw.conf*

    ENABLED=yes

### Tools

    $ aptitude install htop iotop
