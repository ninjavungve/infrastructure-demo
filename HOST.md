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

    $ debootstrap --arch=amd64 --components=main --include=grub-pc,linux-server,lvm2,mdadm,openssh-server,ufw trusty /mnt/server http://archive.ubuntu.com/ubuntu

    Use country mirror (http://de.archive.ubuntu.com/ubuntu) or host provider mirror (http://mirror.hetzner.de/ubuntu/packages) as appropriate.

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

    <some nice name>

*etc/timezone*

    Europe/Berlin

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

    search dc.zargony.com
    nameserver 213.133.98.98
    nameserver 213.133.99.99
    nameserver 213.133.100.100
    nameserver 2a01:4f8:0:a0a1::add:1010
    nameserver 2a01:4f8:0:a102::add:9999
    nameserver 2a01:4f8:0:a111::add:9898

*etc/bash.bashrc*

    force_color_prompt=yes
    . /etc/skel/.bashrc
    alias l='ls -la'

*etc/inputrc*

    set input-meta on
    set output-meta on
    set show-all-if-ambiguous on
    set completion-ignore-case on
    "\e[1~": beginning-of-line
    "\e[2~": quoted-insert
    "\e[3~": delete-char
    "\e[4~": end-of-line
    "\e[A": history-search-backward
    "\e[B": history-search-forward
    "\e[1;5C": forward-word
    "\e[1;5D": backward-word
    "\e[5C": forward-word
    "\e[5D": backward-word
    "\e\e[C": forward-word
    "\e\e[D": backward-word

*etc/vim/vimrc.local*

    syntax on
    set background=dark
    colorscheme elflord
    set showcmd showmatch
    set nowrap
    set ignorecase smartcase hlsearch
    if has("autocmd")
      au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
      filetype plugin indent on
    endif

*etc/apt/sources.list*

    deb http://de.archive.ubuntu.com/ubuntu     trusty          main restricted universe multiverse
    deb http://de.archive.ubuntu.com/ubuntu     trusty-updates  main restricted universe multiverse
    deb http://de.archive.ubuntu.com/ubuntu     trusty-security main restricted universe multiverse
    deb http://security.ubuntu.com/ubuntu       trusty-security main restricted universe multiverse

*etc/apt/sources.list* (Hetzner Mirror)

    deb http://mirror.hetzner.de/ubuntu/packages    trusty          main restricted universe multiverse
    deb http://mirror.hetzner.de/ubuntu/packages    trusty-updates  main restricted universe multiverse
    deb http://mirror.hetzner.de/ubuntu/packages    trusty-security main restricted universe multiverse
    deb http://security.ubuntu.com/ubuntu           trusty-security main restricted universe multiverse

*root/.ssh/authorized_keys*

    ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsSt+5Ennalg+GM7+0/37ukXuYR523DEWHTygpuGH1CI3GG0vMKHquG2lUEOKJ2mh4Pt5OBXxNfKxl3mmaPxyUStcMBwS25AQQhyLkFGp2sRFKpZQrEYozJ1galkPwdG4OsdtZXDdeDodsttDjIKchPPOSh0bHoXvIkA+zzWBu9wxZKc4EhQHN2+cI268NT+mZYFCFLcL2Zpr+eBW1OvnQ5MdG9kh4jYBc2kORXR4CzzCEVnkoibLLM7cczV96jugouVGTpDIYValBERWOM2aUFEbyRo3vAlveAfoFrYWFmvOgT2ynq1wHG6AcbsOOeAeCLO8slimmmgExhxtTEOGzQ== zargony@lina
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwFQFH9XgcgJ2l43yr69sAkql39VKOCVSMfv6jH/ml0WyD0FP2GO1mMoW/teCuRbWqWxXr7fF0QhOi60g1e4xE766Rkll9xBmx+ckPuSj3xmKOUpnn/Z/rjFzwAQ452lJtIGySSNUbfxM00usDF0+kc5wMR1ugnR3S3y2loVN38RzVgUVMm7r1qhnttsUi/HeXFTw1j7Gaqbmz5PEyMKXeI9fvml1wAzf14JMvxjHSQBBvwLuvAAGMPbdd136bIpY+Vpvc3+zXyODLoFOuyl5cuAHULg0thrpifmgrtkLdD2TpKJqqio2kMrS7A0L5Hg+OXD3qlYPFaMl9tZb0QgBl zargony@priya

## Bootloader

Add `panic=60` to the kernel commandline to ensure a reboot after a kernel panic.

*etc/default/grub*

    GRUB_DEFAULT=0
    GRUB_HIDDEN_TIMEOUT=0
    GRUB_HIDDEN_TIMEOUT_QUIET=true
    GRUB_TIMEOUT=2
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

## Docker

    $ aptitude install apt-transport-https
    $ apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
    $ echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" >/etc/apt/sources.list.d/docker.list
    $ aptitude update
    $ aptitude install lxc-docker

*etc/default/docker*

    DOCKER_OPTS="--ipv6 --fixed-cidr-v6 2a01:xxx:xxx::/80 --dns 213.133.98.98 --dns 213.133.99.99 -H unix:///var/run/docker.sock -H tcp://127.0.0.1:2375"

## Useful services

### Relay Mailer

    $ aptitude install ssmtp

*etc/ssmtp/ssmtp.conf*

    root=xxx@xxx.com
    mailhub=mail.your-server.de
    hostname=server.dc.zargony.com

### Monitoring

    $ aptitude install monit

*etc/monit/monitrc*

    set daemon 60 with start delay 30

    set logfile /var/log/monit.log
    set idfile /var/lib/monit/id
    set statefile /var/lib/monit/state
    set eventqueue basedir /var/lib/monit/events slots 100

    set mailserver mail.your-server.de
    set alert xxx@xxx.com not on { instance, action }

    set httpd port 2812 and use address localhost allow localhost only

    check system xxx
      if loadavg (1min) > 5 then alert
      if loadavg (5min) > 3 then alert
      if memory usage > 90% for 5 cycles then alert
      if swap usage > 50% for 5 cycles then alert
      if cpu usage (user) > 90% for 5 cycles then alert
      if cpu usage (system) > 50% for 5 cycles then alert
      if cpu usage (wait) > 40% for 5 cycles then alert

    check process sshd with pidfile /run/sshd.pid
      start program = "/sbin/start ssh"
      stop program = "/sbin/stop ssh"
      if failed host localhost port 22 type tcp protocol ssh then restart

    check process docker with pidfile /run/docker.pid
      start program = "/sbin/start docker"
      stop program = "/sbin/stop docker"

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
    DEFAULT_FORWARD_POLICY="ACCEPT"
    DEFAULT_APPLICATION_POLICY="SKIP"
    MANAGE_BUILTINS=no

*etc/ufw/ufw.conf*

    ENABLED=yes

### Tools

    $ aptitude install apparmor acpid bash-completion bridge-utils ca-certificates curl htop iotop iptraf lftp lsof ltrace ntp pciutils psmisc rsync screen strace tcpdump tmux unattended-upgrades usbutils vim wget
