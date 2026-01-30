# paperless

## Setup your Paperless-Server

```bash
# Create ansible-User an your paperless-host
adduser ansible
usermod -aG sudo ansible
visudo -f /etc/sudoers.d/ansible
# copy & paste
ansible ALL=(ALL) NOPASSWD:ALL

# Ändere Rechte
chmod 440 /etc/sudoers.d/ansible

# Kopiere SSH-Key
ssh-copy-id ansible@172.16.249.75
```

## Execute the Ansible-Workflow to prepare the Ubuntu host, configure the system and install paperless via docker compose

```bash
cd /root/git/paperless/paperless-infra/ansible
ansible-playbook playbooks/site.yml
```

## Befehl zum Kopieren von PDF in den Consume-Ordner

```bash
# Alle PDFs aus dem Ordner /mnt/patrick in den Consume-Ordner kopieren
find /mnt/Patrick -type f \( -iname '*.pdf' -o -iname '*.PDF' \) -exec cp -t /paperless/data/consume/ {} +

# Alle PDFs aus dem Ordner /mnt außer aus dem Ordner /mnt/Patrick in den Consume-Ordner kopieren
find /mnt -path /mnt/Patrick -prune -o -type f -iname '*.pdf' -exec cp -t /paperless/data/consume/ {} +

```