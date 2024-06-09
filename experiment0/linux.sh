#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $0 <?>M"
    exit 1
fi

size=$1
echo "${size}M"

if [ "$1" -eq 1 ]; then
    PORT=56700
elif [ "$1" -eq 2 ]; then
    PORT=56701
elif [ "$1" -eq 5 ]; then
    PORT=56702
elif [ "$1" -eq 10 ]; then
    PORT=56703
elif [ "$1" -eq 20 ]; then
    PORT=56704
elif [ "$1" -eq 50 ]; then
    PORT=56705
elif [ "$1" -eq 100 ]; then
    PORT=56706
else
    echo "Invalid $1M"
    exit 1
fi

SYZKALLER=/home/lxw/experiment0/syzkaller-${size}M
if [ -d "$SYZKALLER" ]; then
    echo "SYZKALLER: $SYZKALLER"
else
    echo "$SYZKALLER don't exist"
    exit 1
fi

WORKDIR=/home/lxw/experiment0/linuxs/workdir-linux-${size}M
CFG=/home/lxw/experiment0/linuxs/linux-${size}M.cfg
IMAGE=/home/lxw/experiment0/image
KERNEL=/home/lxw/experiment0/linux/

echo "{
    \"target\": \"linux/amd64\",
    \"http\": \"0.0.0.0:$PORT\",
    \"workdir\": \"$WORKDIR\",
    \"kernel_obj\": \"$KERNEL\",
    \"image\": \"$IMAGE/bullseye.img\",
    \"sshkey\": \"$IMAGE/bullseye.id_rsa\",
    \"syzkaller\": \"$SYZKALLER\",
    \"procs\": 4,
    \"type\": \"qemu\",
    \"reproduce\" : true,
    \"cover\": true,
    \"raw_cover\" : true,
    \"max_crash_logs\": 100,
    \"vm\": {
        \"count\": 2,
        \"kernel\": \"$KERNEL/arch/x86/boot/bzImage\",
        \"cpu\": 4,
        \"cmdline\": \"selinux=0\",
        \"mem\": 4096
    }
}" > $CFG

timeout 7d $SYZKALLER/bin/syz-manager -config $CFG
