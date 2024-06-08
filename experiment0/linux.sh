#!/bin/sh

PORT=56701
WORKDIR=/home/lxw/experiment0/linuxs/workdir-linux-1m
CFG=/home/lxw/experiment0/linuxs/linux-1m.cfg
SYZKALLER=/home/lxw/experiment0/syzkaller-1M
IMAGE=/home/lxw/experiment0/bullseye
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
        \"mem\": 4096
    }
}" > $CFG

timeout 7d $SYZKALLER/bin/syz-manager -config $CFG
