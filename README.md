
# Steps

First prepare a qcow2 cloud-init image from official source for example from debian website:
https://cloud.debian.org/images/cloud/

After download qemu image we need modify it using a libguestfs-tools to install qemu guest agent package.

Install libguestfs-tools:

```bash
  apt install libguestfs-tools -y
```
Modify image:

```bash
virt-customize --install qemu-guest-agent -a debian-11-generic-amd64.qcow2
```
After modification copy modified image to pve node filesystem.

Clone git repo:
```bash
git clone https://github.com/DigitalDreamerSW/pve-template-cloud-init.git
```
Open cloud-init-pve.sh script and adjust parameters on beginning of the script.

memory: (minimum 512MB, maximum 10240MB)

cpu: (minimum 1, maximum 4)

image_path: path to image for example "/mnt/pve/image.qcow2"

name="" - name of machine which wil be template

bridge_type="vmbr1" or other

storage="local-zfs"or other








## Usefull links

 - [Official proxmxo guide for clud-init](https://pve.proxmox.com/wiki/Cloud-Init_Support)
 - [How to create template in proxmox](https://georgev.design/blog/create-proxmox-cloud-init-templates)
