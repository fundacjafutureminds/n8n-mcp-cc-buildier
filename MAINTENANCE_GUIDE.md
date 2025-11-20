# 🔧 Przewodnik Konserwacji n8n + n8n-mcp

## 📖 Legenda - gdzie wykonywać komendy:

| Ikona | Narzędzie | Opis |
|-------|-----------|------|
| 🖥️ | **Git Bash** | Terminal Git Bash (preferowany) |
| 💻 | **PowerShell** | Windows PowerShell (alternatywa) |
| 🌐 | **Przeglądarka** | Chrome/Firefox/Edge |
| 📝 | **Notatnik** | Notepad lub inny edytor tekstu |
| 🖱️ | **Aplikacja** | Kliknięcia GUI (Docker Desktop, Claude Desktop) |

---

## Spis treści
1. [Uruchamianie systemu](#1-uruchamianie-systemu)
2. [Aktualizacja n8n](#2-aktualizacja-n8n)
3. [Aktualizacja n8n-mcp-cc-buildier](#3-aktualizacja-n8n-mcp-cc-buildier)
4. [Aktualizacja n8n-mcp (lokalny)](#4-aktualizacja-n8n-mcp-lokalny)
5. [Community Nodes](#5-community-nodes)
6. [Backup](#6-backup)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. 🚀 Uruchamianie systemu

### Sekwencja startowa (po restarcie komputera)

#### KROK 1: Uruchom Docker Desktop

🖱️ **Aplikacja - Docker Desktop:**
```
1. Kliknij ikonę Docker Desktop (wieloryb) w menu Start
2. Poczekaj aż ikona przestanie migać (Docker ready)
3. Sprawdź czy działa (następny krok)
```

🖥️ **Git Bash - Sprawdź Docker:**
```bash
docker ps
# Jeśli pokazuje tabelę (nawet pustą) → Docker działa ✅
```

#### KROK 2: Uruchom n8n + n8n-mcp-server

🖥️ **Git Bash:**
```bash
# Przejdź do folderu projektu
cd /c/users/mstrz/onedrive/dokumenty/docker/n8n-mcp-cc-buildier

# Uruchom serwery
./scripts/start_servers.sh
```

**Co się stanie:**
- ✅ Sprawdzi Docker
- ✅ Uruchomi n8n (port 5678)
- ✅ Uruchomi n8n-mcp-server (kontener)
- ✅ Użyje zapisanego API key

**Oczekiwany output:**
```
✅ Docker is installed
✅ Docker Compose is installed
✅ n8n is ready!
✅ MCP server is ready!
🎉 Both services are running!
```

#### KROK 3: Uruchom Claude Desktop

🖱️ **Aplikacja - Menu Start:**
```
1. Uruchom Claude Desktop z menu Start
2. MCP n8n-mcp połączy się automatycznie (lokalny npx)
3. Sprawdź: "Czy widzisz narzędzia n8n-mcp?" → powinno pokazać 42 tools
```

### Sprawdzanie stanu

#### n8n działa?

🖥️ **Git Bash:**
```bash
curl http://localhost:5678/healthz
```

🌐 **Przeglądarka:**
```
Otwórz: http://localhost:5678
Powinieneś zobaczyć interfejs n8n
```

#### Docker kontenery działają?

🖥️ **Git Bash:**
```bash
docker ps
# Powinny być 2 kontenery:
# - n8n-test (port 5678)
# - n8n-mcp-server
```

💻 **PowerShell (alternatywa):**
```powershell
docker ps
```

#### MCP działa?

🖱️ **Aplikacja - Claude Desktop:**
```
1. Otwórz Claude Desktop Chat
2. Napisz: "Czy widzisz narzędzia n8n-mcp?"
3. Powinno pokazać: 42 tools available
```

---

## 2. 🔄 Aktualizacja n8n

### Sprawdź obecną wersję

🖥️ **Git Bash:**
```bash
docker exec n8n-test n8n --version
# Przykład output: 1.71.2
```

💻 **PowerShell (alternatywa):**
```powershell
docker exec n8n-test n8n --version
```

### Aktualizuj do najnowszej wersji

🖥️ **Git Bash:**
```bash
# KROK 1: Przejdź do folderu projektu
cd /c/users/mstrz/onedrive/dokumenty/docker/n8n-mcp-cc-buildier

# KROK 2: Zatrzymaj kontenery
docker compose down

# KROK 3: Pobierz najnowszy obraz n8n
docker pull n8nio/n8n:latest

# KROK 4: Uruchom ponownie (użyje nowej wersji)
./scripts/start_servers.sh

# KROK 5: Sprawdź nową wersję
docker exec n8n-test n8n --version
```

**Co się stanie:**
```
Status: Downloaded newer image for n8nio/n8n:latest
LUB
Status: Image is up to date (jeśli już najnowsza)
```

### Aktualizuj do konkretnej wersji

📝 **Notatnik - Edytuj docker-compose.yml:**
```
1. Otwórz: C:\users\mstrz\onedrive\dokumenty\docker\n8n-mcp-cc-buildier\docker-compose.yml
2. Znajdź linię: image: n8nio/n8n:latest
3. Zmień na: image: n8nio/n8n:1.72.0  (przykład konkretnej wersji)
4. Zapisz (Ctrl+S)
```

🖥️ **Git Bash - Zastosuj zmiany:**
```bash
cd /c/users/mstrz/onedrive/dokumenty/docker/n8n-mcp-cc-buildier

# Zatrzymaj i uruchom ponownie
docker compose down
docker compose pull
./scripts/start_servers.sh
```

### ⚠️ WAŻNE - Twoje dane są bezpieczne!

**Workflow i credentials NIE są w kontenerze!**

Lokalizacja danych:
```
C:\Users\mstrz\.n8n-mcp-test\
├── database.sqlite     ← Wszystkie workflow
├── .n8n/
│   └── credentials/    ← API keys (zaszyfrowane)
└── .n8n-api-key        ← JWT token
```

**Aktualizacja n8n = TYLKO kod aplikacji**
**Dane użytkownika = NIETKNIĘTE**

---

## 3. 🔄 Aktualizacja n8n-mcp-cc-buildier

### Sprawdź czy są aktualizacje

🖥️ **Git Bash:**
```bash
cd /c/users/mstrz/onedrive/dokumenty/docker/n8n-mcp-cc-buildier

# Pobierz info o zmianach
git fetch origin

# Sprawdź status
git status
```

**Możliwe outputy:**

**A) Brak zmian:**
```
Your branch is up to date with 'origin/main'
→ Nie musisz nic robić ✅
```

**B) Są aktualizacje:**
```
Your branch is behind 'origin/main' by 5 commits
→ Aktualizuj (krok poniżej)
```

### Pobierz aktualizacje

🖥️ **Git Bash:**
```bash
# SPOSÓB 1: Standardowy (jeśli NIE miałeś lokalnych zmian)
git pull origin main

# SPOSÓB 2: Jeśli robiłeś lokalne zmiany
git stash              # Zapisz lokalne zmiany
git pull origin main   # Pobierz aktualizacje
git stash pop          # Przywróć lokalne zmiany (jeśli potrzebne)
```

### Co się zaktualizuje?

**Aktualizowane:**
- ✅ Skrypty w `scripts/`
- ✅ Konfiguracje agentów w `.claude/agents/`
- ✅ `docker-compose.yml`
- ✅ Dokumentacja (CLAUDE.md, README.md)

**NIETKNIĘTE:**
- ✅ Twoje workflow (`~/.n8n-mcp-test`)
- ✅ Twoje credentials (`~/.n8n-mcp-test`)
- ✅ API key

### Po aktualizacji - restart

🖥️ **Git Bash (jeśli zmienił się docker-compose.yml):**
```bash
docker compose down
./scripts/start_servers.sh
```

---

## 4. 🔄 Aktualizacja n8n-mcp (lokalny npm)

### Sprawdź obecną wersję

🖥️ **Git Bash:**
```bash
npx n8n-mcp --version
# Przykład: 1.0.0
```

💻 **PowerShell (alternatywa):**
```powershell
npx n8n-mcp --version
```

### Sprawdź czy jest nowsza wersja

🖥️ **Git Bash:**
```bash
npm view n8n-mcp version
# Porównaj z Twoją wersją powyżej
```

### Aktualizuj

🖥️ **Git Bash:**
```bash
npm update -g n8n-mcp
```

💻 **PowerShell (alternatywa):**
```powershell
npm update -g n8n-mcp
```

### Sprawdź nową wersję

🖥️ **Git Bash:**
```bash
npx n8n-mcp --version
# Powinna być nowsza
```

### Po aktualizacji - restart Claude Desktop

🖥️ **Git Bash:**
```bash
# Zamknij Claude Desktop całkowicie
taskkill.exe /IM "Claude.exe" /F
```

💻 **PowerShell (alternatywa):**
```powershell
# Zamknij Claude Desktop całkowicie
taskkill /IM "Claude.exe" /F
```

🖱️ **Aplikacja - Menu Start:**
```
Uruchom Claude Desktop ponownie z menu Start
```

**Nie trzeba zmieniać `claude_desktop_config.json`** - używa `npx n8n-mcp` (zawsze najnowsza zainstalowana wersja)

---

## 5. 📦 Community Nodes

### Gdzie są Community Nodes?

**Community nodes NIE są w n8n-mcp-cc-buildier!**

```
n8n-mcp-cc-buildier    ← Skrypty i konfiguracja
~/.n8n-mcp-test        ← Twoje workflow i dane
                       └── nodes/  ← TUTAJ są community nodes!
```

### Jak zainstalować Community Node?

#### SPOSÓB 1: Przez n8n UI (polecane)

🌐 **Przeglądarka:**
```
1. Otwórz http://localhost:5678
2. Kliknij Settings (⚙️) w lewym dolnym rogu
3. Kliknij Community Nodes
4. Kliknij "Install a community node"
5. Wpisz nazwę pakietu (np. n8n-nodes-telegram)
6. Kliknij "Install"
7. Poczekaj na instalację
```

🖥️ **Git Bash - Restart n8n:**
```bash
cd /c/users/mstrz/onedrive/dokumenty/docker/n8n-mcp-cc-buildier
docker compose restart n8n
```

#### SPOSÓB 2: Ręcznie (zaawansowane)

🖥️ **Git Bash:**
```bash
# Wejdź do kontenera n8n
docker exec -it n8n-test sh

# Zainstaluj node (WEWNĄTRZ kontenera)
npm install n8n-nodes-telegram

# Wyjdź z kontenera
exit

# Restart kontenera
cd /c/users/mstrz/onedrive/dokumenty/docker/n8n-mcp-cc-buildier
docker compose restart n8n
```

### Lista popularnych Community Nodes

```
n8n-nodes-telegram       - Telegram bots
n8n-nodes-discord        - Discord integration
n8n-nodes-youtube        - YouTube API
n8n-nodes-document-generator - PDF/DOCX generation
```

### Sprawdź zainstalowane Community Nodes

🌐 **Przeglądarka:**
```
1. Otwórz http://localhost:5678
2. Settings → Community Nodes
3. Lista zainstalowanych nodes
```

### ⚠️ UWAGA po aktualizacji n8n

**Community nodes mogą przestać działać** po aktualizacji n8n (incompatibility).

**Rozwiązanie:**
1. Sprawdź kompatybilność na npmjs.com
2. Zaktualizuj community node do nowszej wersji
3. Lub poczekaj aż autor node'a zaktualizuje

---

## 6. 💾 Backup

### Co backupować?

#### A) KRYTYCZNE - Twoje dane (workflow + credentials)

🖥️ **Git Bash:**
```bash
# Backup wszystkiego
cp -r ~/.n8n-mcp-test ~/Backup/n8n-data-$(date +%Y%m%d)
```

💻 **PowerShell:**
```powershell
# Backup wszystkiego
Copy-Item -Recurse -Path "$env:USERPROFILE\.n8n-mcp-test" -Destination "$env:USERPROFILE\Backup\n8n-data-$(Get-Date -Format 'yyyyMMdd')"
```

**Zawiera:**
- ✅ Wszystkie workflow
- ✅ Credentials (zaszyfrowane)
- ✅ Execution history
- ✅ Settings

#### B) OPCJONALNIE - Projekt (skrypty)

🖥️ **Git Bash:**
```bash
# Backup projektu
cp -r /c/users/mstrz/onedrive/dokumenty/docker/n8n-mcp-cc-buildier ~/Backup/n8n-project-$(date +%Y%m%d)
```

**Zawiera:**
- Skrypty
- Konfiguracje agentów
- docker-compose.yml

**ALE:** To jest w git, więc nie tak krytyczne!

### Restore z backup

🖥️ **Git Bash:**
```bash
# KROK 1: Zatrzymaj n8n
cd /c/users/mstrz/onedrive/dokumenty/docker/n8n-mcp-cc-buildier
docker compose down

# KROK 2: Przywróć dane
cp -r ~/Backup/n8n-data-20241115/* ~/.n8n-mcp-test/

# KROK 3: Uruchom ponownie
./scripts/start_servers.sh
```

### Częstotliwość backup

**Zalecane:**
- **Co tydzień** - jeśli aktywnie tworzysz workflow
- **Przed aktualizacją** n8n - zawsze!
- **Po stworzeniu ważnego workflow** - od razu

---

## 7. 🔧 Troubleshooting

### Problem: n8n nie startuje

#### Sprawdź:

🖥️ **Git Bash - Logi n8n:**
```bash
docker logs n8n-test
```

🖥️ **Git Bash - Czy Docker działa:**
```bash
docker ps
```

🖥️ **Git Bash - Czy port 5678 jest wolny:**
```bash
netstat -ano | findstr :5678
# Jeśli coś pokazuje → port zajęty
```

💻 **PowerShell (alternatywa - port):**
```powershell
netstat -ano | findstr :5678
```

#### Rozwiązanie:

🖥️ **Git Bash - Restart wszystkiego:**
```bash
cd /c/users/mstrz/onedrive/dokumenty/docker/n8n-mcp-cc-buildier
docker compose down
docker compose up -d
```

---

### Problem: Claude Desktop nie widzi MCP tools

#### Sprawdź:

🖥️ **Git Bash - Czy n8n-mcp jest zainstalowany:**
```bash
npx n8n-mcp --version
```

💻 **PowerShell - Sprawdź config:**
```powershell
notepad $env:APPDATA\Claude\claude_desktop_config.json
```

#### Rozwiązanie:

🖥️ **Git Bash - Reinstall n8n-mcp:**
```bash
npm install -g n8n-mcp

# Restart Claude Desktop
taskkill.exe /IM "Claude.exe" /F
# Uruchom ponownie z menu Start
```

---

### Problem: API key nie działa

**Objawy:**
```
MCP server initialized with 23 tools (n8n API: not configured)
```

#### Rozwiązanie:

🖥️ **Git Bash - Sprawdź czy API key jest zapisany:**
```bash
cat ~/.n8n-mcp-test/.n8n-api-key
```

🌐 **Przeglądarka - Wygeneruj nowy w n8n UI:**
```
1. Otwórz http://localhost:5678
2. Settings → API
3. Create API Key
4. Skopiuj klucz
```

📝 **Notatnik - Zaktualizuj Claude Desktop config:**
```
1. Otwórz: %APPDATA%\Claude\claude_desktop_config.json
2. Znajdź: "N8N_API_KEY": "..."
3. Wklej nowy klucz
4. Zapisz (Ctrl+S)
```

🖥️ **Git Bash - Restart Claude Desktop:**
```bash
taskkill.exe /IM "Claude.exe" /F
# Uruchom ponownie
```

---

### Problem: Workflow nie działa po aktualizacji

**Możliwe przyczyny:**
1. Community node niekompatybilny z nową wersją n8n
2. Zmiana w API node'a
3. Zmiana w składni wyrażeń

#### Rozwiązanie:

🌐 **Przeglądarka - Sprawdź execution history:**
```
1. Otwórz http://localhost:5678
2. Kliknij na workflow
3. Executions → Zobacz dokładny błąd
```

**Następne kroki:**
1. Sprawdź kompatybilność community nodes na npmjs.com
2. Zaktualizuj community node do nowszej wersji
3. Dopasuj konfigurację node'ów

---

## 📅 Rutynowa konserwacja (checklist)

### Co tydzień
- [ ] 🖱️ Sprawdź czy Docker Desktop ma aktualizacje (Settings w aplikacji)
- [ ] 🖥️ Backup danych workflow (Git Bash: `cp -r ~/.n8n-mcp-test ~/Backup/...`)

### Co miesiąc
- [ ] 🖥️ Aktualizuj n8n (Git Bash: `docker pull n8nio/n8n:latest`)
- [ ] 🖥️ Aktualizuj n8n-mcp (Git Bash: `npm update -g n8n-mcp`)
- [ ] 🖥️ Aktualizuj projekt (Git Bash: `git pull origin main`)
- [ ] 🌐 Sprawdź czy community nodes są kompatybilne (n8n UI)

### Przed każdą aktualizacją n8n
- [ ] 🖥️ Backup danych (Git Bash: `cp -r ~/.n8n-mcp-test ~/Backup/...`)
- [ ] 🌐 Sprawdź changelog n8n (https://github.com/n8n-io/n8n/releases)
- [ ] 🌐 Sprawdź kompatybilność community nodes (npmjs.com)

---

## 📞 Pomoc

**Problemy z n8n:**
- https://docs.n8n.io
- https://community.n8n.io

**Problemy z n8n-mcp:**
- https://www.n8n-mcp.com
- https://github.com/czlonkowski/n8n-mcp

**Problemy z projektem:**
- https://github.com/fundacjafutureminds/n8n-mcp-cc-buildier/issues

---

**Ostatnia aktualizacja:** 2024-11-15 (v2 - dodano ikony narzędzi)
**Autor:** n8n-mcp-cc-buildier project
