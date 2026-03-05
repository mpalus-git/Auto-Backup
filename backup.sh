#!/bin/bash

SOURCE_DIR="$HOME/dane"
BACKUP_DIR="$HOME/backups"
RETENTION_DAYS=7
LOG_FILE="$BACKUP_DIR/backup.log"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="backup_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"

log_message() {
    local message="$1"
    local log_timestamp
    log_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[${log_timestamp}] ${message}" >> "$LOG_FILE"
    echo "[${log_timestamp}] ${message}"
}

if [ ! -d "$SOURCE_DIR" ]; then
    log_message "BŁĄD: Katalog źródłowy '${SOURCE_DIR}' nie istnieje. Przerywam."
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    log_message "INFO: Utworzono katalog docelowy '${BACKUP_DIR}'."
fi

log_message "INFO: Rozpoczynam tworzenie kopii zapasowej..."
log_message "INFO: Źródło:  ${SOURCE_DIR}"
log_message "INFO: Cel:     ${ARCHIVE_PATH}"

OUTPUT=$(tar czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>&1)

if [ $? -eq 0 ]; then
    ARCHIVE_SIZE=$(du -h "$ARCHIVE_PATH" | cut -f1)
    log_message "SUKCES: Kopia zapasowa utworzona - ${ARCHIVE_NAME} (${ARCHIVE_SIZE})."
else
    log_message "BŁĄD: Nie udało się utworzyć archiwum. Szczegóły: ${OUTPUT}"
    exit 1
fi

log_message "INFO: Szukam archiwów starszych niż ${RETENTION_DAYS} dni w '${BACKUP_DIR}'..."

OLD_FILES=$(find "$BACKUP_DIR" -maxdepth 1 -type f -name "backup_*.tar.gz" -mtime +${RETENTION_DAYS})

if [ -z "$OLD_FILES" ]; then
    log_message "INFO: Brak archiwów do usunięcia."
else
    while IFS= read -r file; do
        rm -f "$file"
        log_message "USUNIĘTO: Stare archiwum - $(basename "$file")"
    done <<< "$OLD_FILES"
fi

log_message "INFO: Proces kopii zapasowej zakończony pomyślnie."
log_message "────────────────────────────────────────────────────────────────"

exit 0
