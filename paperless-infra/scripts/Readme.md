# Backup & Restore

## Backup

```bash
# Backup durchführen
sudo /paperless-backup/paperless-backup.sh
```

## Restore

```bash
# Paperless anhalten
cd /paperless/docker
docker compose down
cd ~
# Original (korruptes) Paperless verschieben
mv /paperless /paperless-before-restore

# Restore durchführen
sudo /paperless-backup/paperless-restore.sh /paperless-backups/paperless/paperless-paperless-2025-11-29_18-33-00.tar.gz
```
