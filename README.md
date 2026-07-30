# homelab-infra

Provisions the Proxmox VM and installs k3s on it.
Cluster workloads live in `homelab-cluster`.

## Notes

- Proxmox is installed from ISO by hand. Everything above that is code.
- Never SSH into the VM to fix things — add the task to the playbook and rebuild.


## Layout

```
scripts/   one-off template build on Proxmox
tofu/      creates the VM (Proxmox API)
ansible/   configures OS, installs k3s (SSH)
```

## Prerequisites

Everything runs from the laptop.

**macOS**

```bash
brew install opentofu ansible kubernetes-cli
```

**Debian/Ubuntu**

```bash
curl -fsSL https://get.opentofu.org/install-opentofu.sh | sh -s -- --install-method deb
sudo apt install -y ansible
sudo snap install kubectl --classic
```

**Proxmox API token**

`Datacenter → Permissions → API Tokens` — uncheck "Privilege Separation".

## Proxmox template

Builds the Ubuntu cloud-init template that Tofu clones.

```bash
ssh root@<proxmox-ip> 'bash -s' < scripts/proxmox-template.sh
```

Templates are versioned, never overwritten. To bump the Ubuntu release, raise
`VMID` in the script (9000 → 9001), re-run it, and point `template_vm_id` in
`tofu/terraform.tfvars` at the new one. Old templates stay until nothing uses them.

## Usage

```bash
cd tofu && tofu init && tofu apply
ssh root@<proxmox-ip> # to generate ssh keys
ansible-galaxy install -r ansible/requirements.yml
ansible-playbook k3s.orchestration.site -i ansible/inventory.yml
```

Cluster access:

```bash
kubectl config use-context k3s-ansible
kubectl get nodes
```
