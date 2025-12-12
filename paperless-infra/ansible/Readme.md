# Paperless-Infrastruktur mit Ansible

Diese Dokumentation beschreibt, wie du die Playbooks und Rollen in `paperless-infra/ansible` verwendest, um einen frischen Ubuntu-Server für Paperless-ngx vorzubereiten, Docker zu installieren und den Stack inklusive Backup/Restore-Skripten auszurollen.

## Voraussetzungen

- **Control-Host:** Linux/macOS/WSL mit Ansible ≥ 2.15, Python 3 und SSH-Zugang zum Zielsystem.
- **Zielsystem:** Ubuntu 24.04 LTS (andere Debian-Derivate funktionieren meist ebenfalls) mit root-Zugang zur Erstkonfiguration.
- **SSH-Schlüssel:** Der Steuerrechner sollte sich per Schlüssel anmelden können.

### Ansible-Benutzer am Zielsystem anlegen

Die Playbooks greifen nicht als root zu, sondern verwenden einen dedizierten sudo-Benutzer (`ansible` als Standard). Auf dem Server einmalig anlegen:

```bash
sudo adduser ansible
sudo usermod -aG sudo ansible
echo "ansible ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ansible
sudo chmod 440 /etc/sudoers.d/ansible
```

## Inventar und Variablen

1. **Inventory (`inventory/hosts.ini`):**

   ```ini
   [paperless]
   paperless ansible_host=172.16.249.152
   ```

   Falls du einen anderen SSH-Benutzer nutzt, ergänze `ansible_user=<name>`.

2. **Gruppenvariablen (`inventory/group_vars/paperless.yml`):** Hier legst du alle installationsspezifischen Werte fest (Pfad `paperless_root`, gewünschte Paperless-Version `paperless_image_tag`, Hostname/IP, Admin-Zugangsdaten sowie Firewall-Ports). Sensible Daten lassen sich optional mit Ansible Vault verschlüsseln.

3. **Roll-Defaults (`roles/paperless/defaults/main.yml`):** Liefert sinnvolle Standardwerte für Ordnerstruktur, Docker-Compose-Dateien und Backup-Skripte. Überschreibe sie bei Bedarf in `group_vars`.

## Playbooks und Rollen im Überblick

| Playbook | Zweck | Enthaltene Rollen |
|----------|-------|-------------------|
| `playbooks/setup-ubuntu.yml` | Grundhärtung + Docker | `common`, `docker` |
| `playbooks/deploy-paperless.yml` | Nur Paperless-Stack (z. B. nach Variablenänderungen) | `paperless` |
| `playbooks/site.yml` | Vollständige Erstinstallation oder Neuaufsetzen | `common`, `docker`, `paperless` |

**Rollen:**

- `common`: Updates, Zeitzone, Basis-Pakete, unattended-upgrades, UFW-Regeln inkl. Ports aus `firewall_allowed_tcp_ports`, Paperless-Systemnutzer und optionalen vsftpd-Server mit Template `vsftpd.conf.j2`.
- `docker`: Fügt das offizielle Docker-Repository samt GPG-Key hinzu, installiert Engine/Compose-Plugin und startet den Dienst.
- `paperless`: Erstellt die Verzeichnisstruktur, rendert `docker-compose.yml` und `.env`, setzt Besitzrechte, legt Backup-/Restore-Skripte ab und startet den Stack via `docker compose up -d`. Anschließend wird gewartet, bis das Web-UI antwortet, ein Admin-Token generiert und Hilfsskripte für Korrespondenzen, Dokumenttypen und Tags bereitgestellt.

## Schritt-für-Schritt-Ablauf

1. **Konfiguration prüfen:** Variablen in `inventory/group_vars/paperless.yml` setzen und ggf. Templates (`roles/paperless/templates/*`) anpassen.
2. **Verbindung testen:**

   ```bash
   ansible -i inventory/hosts.ini paperless -m ping
   ```

3. **Basis-Setup (optional nach frischem Server):**

   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/setup-ubuntu.yml --ask-become-pass
   ```

4. **Paperless ausrollen oder aktualisieren:**

   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/deploy-paperless.yml --ask-become-pass
   ```

5. **Komplettinstallation in einem Rutsch:**

   ```bash
   ansible-playbook -i inventory/hosts.ini playbooks/site.yml --ask-become-pass
   ```

   Ergänze bei Bedarf `-u <ssh-user>` oder `--limit paperless` für einzelne Hosts.

Die Paperless-Rolle wartet automatisch mit dem Tag `waitforpaperless`, bis das Webinterface über `PAPERLESS_URL` (Standard: `http://{{ paperless_hostname }}`) erreichbar ist. Erst danach werden Token erstellt und Skripte generiert.

## Troubleshooting und nützliche Kommandos

- Firewall-Variablen prüfen:

  ```bash
  ansible -i inventory/hosts.ini all -m debug -a "var=firewall_allowed_tcp_ports"
  ```

- Ausgabe einzelner Aufgaben erhöhen: `ansible-playbook ... -vvv`.
- Nur einen Teil starten (z. B. Templates rendern): `ansible-playbook ... --tags template`.
- Falls der Docker-Service nicht startet, erneut die Rolle `docker` ausführen: `ansible-playbook ... --tags docker`.

## Nach der Installation

- Web-UI unter `http://<paperless_hostname>:<paperless_http_port>` testen.
- Mit dem generierten Token (Ansible-Output) Skripte in `{{ paperless_scripts_dir }}` auf dem Server ausführen, um Korrespondenzen, Dokumenttypen und Tags zu erzeugen.
- Backup-Ziel in `paperless_backup_dir` einhängen und die bereitgestellten Skripte (`paperless-backup.sh`, `paperless-restore.sh`) z. B. per Cron einplanen.
