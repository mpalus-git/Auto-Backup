# Auto Backup

Skrypt Bash do automatycznego tworzenia skompresowanych kopii zapasowych z wbudowaną rotacją - automatycznie usuwa archiwa starsze niż zadana liczba dni.

## Funkcje

- **Kompresja tar.gz** - tworzy archiwum katalogu źródłowego z sygnaturą czasową w nazwie
- **Automatyczna rotacja** - usuwa kopie starsze niż zdefiniowany okres retencji
- **Logowanie** - każda operacja jest rejestrowana w pliku logu oraz wypisywana na standardowe wyjście
- **Walidacja** - sprawdza istnienie katalogu źródłowego i automatycznie tworzy katalog docelowy

## Wymagania

- Bash 4.0+
- Narzędzia: `tar`, `find`, `du`

## Konfiguracja

Zmienne konfiguracyjne znajdują się na początku pliku `backup.sh`:

| Zmienna          | Domyślna wartość   | Opis                                      |
|------------------|--------------------|--------------------------------------------|
| `SOURCE_DIR`     | `$HOME/dane`      | Katalog, którego kopia jest tworzona        |
| `BACKUP_DIR`     | `$HOME/backups`   | Katalog docelowy na archiwa                |
| `RETENTION_DAYS` | `7`                | Liczba dni przechowywania starych archiwów |

## Instalacja

```bash
git clone https://github.com/mpalus-git/Auto-Backup.git
cd auto-backup
chmod +x backup.sh
```

## Użycie

```bash
./backup.sh
```

### Automatyzacja przez cron

Aby uruchamiać skrypt codziennie o 2:00 w nocy:

```bash
crontab -e
```

Dodaj linię:

```
0 2 * * * /ścieżka/do/backup.sh
```

## Struktura archiwów

Archiwa są zapisywane w formacie:

```
backup_RRRR-MM-DD_GG-MM-SS.tar.gz
```

## Logi

Logi zapisywane są do pliku `backup.log` w katalogu docelowym. Przykładowy wpis:

```
[2026-03-05 02:00:01] INFO: Rozpoczynam tworzenie kopii zapasowej...
[2026-03-05 02:00:01] INFO: Źródło:  /home/user/dane
[2026-03-05 02:00:01] INFO: Cel:     /home/user/backups/backup_2026-03-05_02-00-01.tar.gz
[2026-03-05 02:00:03] SUKCES: Kopia zapasowa utworzona - backup_2026-03-05_02-00-01.tar.gz (15M).
[2026-03-05 02:00:03] INFO: Brak archiwów do usunięcia.
[2026-03-05 02:00:03] INFO: Proces kopii zapasowej zakończony pomyślnie.
```
