# Verbindung zum Server testen

All-in-One-Playbook

```bash
# Das macht wirklich alles von A-Z
ansible-playbook -i inventory/hosts.ini playbooks/site.yml -u jahnpa --ask-become-pass
```

```bash
# Troubleshooting
ansible -m ping all
ansible -i inventory/hosts.ini all -m debug -a "var=firewall_allowed_tcp_ports"
```

## Basis-Setup für Ubuntu-Server ausführen

```bash
ansible-playbook playbooks/setup-ubuntu.yml --ask-become-pass
```
