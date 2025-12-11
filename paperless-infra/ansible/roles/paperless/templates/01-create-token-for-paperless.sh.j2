#!/usr/bin/env bash

# Konfiguration
CONTAINER="docker-webserver-1"
MANAGE_PATH="/usr/src/paperless/src/manage.py"

# Benutzername als Argument oder Default "admin"
USER="${1:-admin}"

echo "→ Erzeuge/lese API-Token für Benutzer: $USER"
echo

# Befehl im Container ausführen
RAW_OUTPUT=$(docker exec -i "$CONTAINER" python3 "$MANAGE_PATH" drf_create_token "$USER" 2>&1)
EXIT_CODE=$?

# Original-Ausgabe anzeigen (hilfreich zum Debuggen)
echo "$RAW_OUTPUT"
echo

if [ $EXIT_CODE -ne 0 ]; then
  echo "❌ Fehler beim Ausführen von drf_create_token (Exit-Code $EXIT_CODE)."
  echo "   Prüfe, ob der Benutzer '$USER' existiert."
  exit $EXIT_CODE
fi

# Versuchen, den Token (40-stellige Hex-Zeichenkette) aus der Ausgabe zu extrahieren
TOKEN=$(echo "$RAW_OUTPUT" | grep -Eo '[0-9a-f]{40}' | head -n1)

if [ -n "$TOKEN" ]; then
  echo "✅ API-Token erfolgreich ermittelt:"
  echo
  echo "================ API TOKEN ================"
  echo "$TOKEN"
  echo "=========================================="
  echo
  echo "Diesen Token kannst du z.B. so in curl verwenden:"
  echo "  curl -H \"Authorization: Token $TOKEN\" http://paperless.home.local/api/documents/"
  exit 0
else
  echo "❌ Konnte keinen Token aus der Ausgabe extrahieren."
  echo "   Die Ausgabe oben zeigt, was schiefgelaufen ist."
  exit 1
fi
