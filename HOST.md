# Setting up a real host

Assuming that a the real host has two hard drives that should be mirrored, start a rescue system from an external media.

## Create and mount root filesystem

### Option 1: MDADM and LVM

    $ fdisk /dev/sda      # create a single primary partition of type FD (Linux RAID autodetect))
    $ fdisk /dev/sdb      # ditto
    $ mdadm --create /dev/md/0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
    $ pvcreate /dev/md/0
    $ vgcreate vg0 /dev/md/0
    $ lvcreate -L 2G -n server_root vg0
    $ mkfs.ext4 /dev/vg0/server_root
    $ lvcreate -L 1G -n server_swap vg0
    $ mkswap -c /dev/vg0/server_swap
    $ mkdir /mnt/server
    $ mount /dev/vg0/server_root /mnt/server

### Option 2: BTRFS

    $ mkfs.btrfs /dev/sda /dev/sdb
    $ mkdir /mnt/server
    $ mount /dev/sda /mnt/server

## Install base system

    $ ./bootstrap.sh /mnt/server

## Configuration

*etc/mdadm/mdadm.conf*

    DEVICE partitions
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
    nameserver 213.133.100.100
    nameserver 213.133.99.99
    nameserver 213.133.98.98

*root/.ssh/authorized_keys*

    ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsSt+5Ennalg+GM7+0/37ukXuYR523DEWHTygpuGH1CI3GG0vMKHquG2lUEOKJ2mh4Pt5OBXxNfKxl3mmaPxyUStcMBwS25AQQhyLkFGp2sRFKpZQrEYozJ1galkPwdG4OsdtZXDdeDodsttDjIKchPPOSh0bHoXvIkA+zzWBu9wxZKc4EhQHN2+cI268NT+mZYFCFLcL2Zpr+eBW1OvnQ5MdG9kh4jYBc2kORXR4CzzCEVnkoibLLM7cczV96jugouVGTpDIYValBERWOM2aUFEbyRo3vAlveAfoFrYWFmvOgT2ynq1wHG6AcbsOOeAeCLO8slimmmgExhxtTEOGzQ== zargony@lina
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwFQFH9XgcgJ2l43yr69sAkql39VKOCVSMfv6jH/ml0WyD0FP2GO1mMoW/teCuRbWqWxXr7fF0QhOi60g1e4xE766Rkll9xBmx+ckPuSj3xmKOUpnn/Z/rjFzwAQ452lJtIGySSNUbfxM00usDF0+kc5wMR1ugnR3S3y2loVN38RzVgUVMm7r1qhnttsUi/HeXFTw1j7Gaqbmz5PEyMKXeI9fvml1wAzf14JMvxjHSQBBvwLuvAAGMPbdd136bIpY+Vpvc3+zXyODLoFOuyl5cuAHULg0thrpifmgrtkLdD2TpKJqqio2kMrS7A0L5Hg+OXD3qlYPFaMl9tZb0QgBl zargony@priya
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzz9mVFVI6HLTYxV352Q2/9M6pjaWWHXFDJ3+f7j6LceI596rLL2ITgqhxtfN8S2yHWi/8UsBy0xykwsyS7BRmh76/m0nCG+djrqPidG8uZPasicRZyIz/5LxYsi6i9gw/FGv8oL8MvCqilB/zpAqy0/FQEC9wWysbvbB33+q0eJ4wa2FVGm2KW19WkPOysC4jKrc99FcX2pZld5QhU3f6FocTNH4Baq6opzf65SfV40Rp6mERn3FuVrZivcmGt8K7t6rvidQEPxfnoFuuCxN6ZnXAZIOxbFcjqadjI9XaVFPkrtR/5a5xyyOEGDuzN0crxNI8Wd9gYUcbpgCH+R1l zargony@ios

## Bootloader

Add `panic=60` to the kernel commandline to ensure a reboot after a kernel panic.

*etc/default/grub*

    GRUB_DEFAULT=0
    GRUB_HIDDEN_TIMEOUT=0
    GRUB_HIDDEN_TIMEOUT_QUIET=true
    GRUB_TIMEOUT=10
    GRUB_CMDLINE_LINUX_DEFAULT=""
    GRUB_CMDLINE_LINUX="panic=60"
    GRUB_DISABLE_OS_PROBER="true"

Install the bootloader to both harddisks.

    $ mount -t proc none /mnt/server/proc
    $ mount -o bind /dev /mnt/server/dev
    $ chroot /mnt/server /sbin/update-grub
    $ chroot /mnt/server /sbin/grub-install /dev/sda
    $ chroot /mnt/server /sbin/grub-install /dev/sdb

## Restart

    $ umount /mnt/server/dev
    $ umount /mnt/server/proc
    $ umount /mnt/server
    $ sync
    $ reboot
