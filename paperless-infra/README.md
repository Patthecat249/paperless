# 📄 Paperless Infrastructure (paperless-infra)

Dieses Repository enthält die komplette Infrastruktur, Dokumentation und Automatisierung zur Installation, Konfiguration und Verwaltung einer **Paperless-ngx Instanz** auf einem **Ubuntu 24.04 LTS Server**.

Ziel ist eine **reproduzierbare, deklarative und leicht wartbare Installation**, basierend auf:

- Ubuntu 24.04 LTS
- Docker & Docker Compose
- Ansible (für Provisionierung & Updates)
- Saubere Dokumentation der gesamten Umgebung

---

## 🚀 Features

- Vollständige **Ansible-Automatisierung**
- Klare, modulare **Ordnerstruktur**
- Automatische Installation von:
  - Docker Engine
  - docker-compose plugin
  - Paperless-ngx
  - PostgreSQL (optional)
- Einfache Backups über Skripte oder Ansible-Playbook
- Wiederholbare Installation auf jedem beliebigen Server
- Dokumentation als Markdown (Docs-as-Code)

---

## 🗂️ Repository-Struktur

```bash
paperless-infra/
├── README.md
├── docs/
├── ansible/
│   ├── inventory/
│   ├── group_vars/
│   ├── roles/
│   └── playbooks/
├── docker/
└── scripts/
```

---

## 🛠️ Voraussetzungen

- 🐧 **Ubuntu Server 24.04 LTS**
- 🔐 SSH-Zugang (z. B. via `ubuntu`-User)
- 🧰 Lokal installiert:
  - Ansible ≥ 2.10
  - Git
- 📦 Zielsystem benötigt:
  - Internetzugang (für Docker & Images)
  - 2–4 GB RAM empfohlen

---

## 🔧 Installation / Deployment

### 1️⃣ Repository klonen

```bash
git clone https://github.com/<dein-user>/paperless-infra.git
cd paperless-infra/ansible
```

### 2️⃣ Inventory anpassen

Datei: `ansible/inventory/hosts.ini`

```ini
[paperless]
paperless01 ansible_host=192.168.1.50 ansible_user=ubuntu
```

### 3️⃣ Grundinstallation durchführen

```bash
ansible-playbook -i inventory/hosts.ini playbooks/setup-ubuntu.yml
ansible-playbook -i inventory/hosts.ini playbooks/deploy-paperless.yml
```

Danach ist Paperless-ngx auf dem Server verfügbar.

---

## 🐳 Docker-Konfiguration

Alle Docker-Definitionen liegen im Ordner:

```bash
docker/
```

Wichtige Dateien:

- `docker-compose.yml`
- `.env.example`
- `docker-compose.dev.yml` (optional)

Diese werden per Ansible nach `/opt/paperless/` übertragen.

---

## 📦 Backups

### 1️⃣ Backup per Skript

```bash
./scripts/backup.sh
```

### 2️⃣ Backup per Ansible

```bash
ansible-playbook -i inventory/hosts.ini playbooks/backup.yml
```

Gesichert werden:

- PostgreSQL Dump
- `media/` Ordner
- `consume/` Ordner
- `docker-compose.yml`
- `.env`

---

## 🔄 Restore

Ein Restore erfolgt per:

```bash
./scripts/restore.sh
```

Oder manuell:

1. Medienverzeichnis zurückkopieren
2. PostgreSQL Dump importieren
3. `docker compose up -d` ausführen

Details siehe: `docs/40-backup-restore.md`

---

## 📚 Dokumentation

Der Ordner `docs/` enthält strukturierte Informationen:

- **00-overview.md** – Projektübersicht
- **10-ubuntu24-basics.md** – Basisinstallation
- **20-docker-setup.md** – Docker & Compose
- **30-paperless-config.md** – Paperless-ngx Konfiguration
- **40-backup-restore.md** – Backup & Restore
- **50-ansible-howto.md** – Ansible Nutzungsanleitungen

---

## 🧪 Entwicklung / Tests

Für lokale Tests existiert eine Entwicklungs-Variante:

```bash
docker/docker-compose.dev.yml
```

---

## 🤝 Mitwirken

Pull Requests, Bug Reports und Verbesserungen sind willkommen.
Dieses Repository soll eine moderne, robuste und leicht wartbare Paperless-Infrastruktur bereitstellen.

---

## 📜 Lizenz

Dieses Projekt empfiehlt die Verwendung der **MIT-Lizenz**.
Die Datei `LICENSE` kann bei Bedarf angepasst werden.
