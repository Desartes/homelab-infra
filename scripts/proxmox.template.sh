#!/usr/bin/env bash
set -euo pipefail

VMID=9000
STORAGE=local-lvm
IMG=noble-server-cloudimg-amd64.img

apt-get install -y libguestfs-tools

cd /var/lib/vz/template/iso
[ -f "$IMG" ] || wget "https://cloud-images.ubuntu.com/noble/current/$IMG"

virt-customize -a "$IMG" --install qemu-guest-agent
virt-customize -a "$IMG" --truncate /etc/machine-id

qm create $VMID --name ubuntu-2404-template --machine q35 \
  --cpu host --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-single

qm set $VMID --scsi0 "$STORAGE:0,import-from=$(pwd)/$IMG,discard=on,ssd=1"
qm set $VMID --ide2 "$STORAGE:cloudinit"
qm set $VMID --boot order=scsi0
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --agent enabled=1

qm template $VMID