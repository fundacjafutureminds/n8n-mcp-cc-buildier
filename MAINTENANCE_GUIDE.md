# 🔧 Przewodnik Konserwacji n8n + n8n-mcp

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
```
1. Kliknij ikonę Docker Desktop (wieloryb)
2. Poczekaj aż ikona przestanie migać (Docker ready)
3. Sprawdź: docker ps (powinno działać bez błędu)
```

#### KROK 2: Uruchom n8n + n8n-mcp-server

**Git Bash:**
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

```
1. Uruchom Claude Desktop z menu Start
2. MCP n8n-mcp połączy się automatycznie (lokalny npx)
3. Sprawdź: "Czy widzisz narzędzia n8n-mcp?" → powinno pokazać 42 tools
```

### Sprawdzanie stanu

**n8n działa?**
```bash
curl http://localhost:5678/healthz
# Lub otwórz w przeglądarce: http://localhost:5678
```

**Docker kontenery działają?**
```bash
docker ps
# Powinny być 2 kontenery:
# - n8n-test
# - n8n-mcp-server
```

**MCP działa?**
```
Claude Desktop → Chat → "Czy widzisz narzędzia n8n-mcp?"
```

---

## 2. 🔄 Aktualizacja n8n

### Sprawdź obecną wersję

```bash
docker exec n8n-test n8n --version
# Przykład output: 1.71.2
```

### Aktualizuj do najnowszej wersji

```bash
# KROK 1: Zatrzymaj kontenery
cd /c/users/mstrz/onedrive/dokumenty/docker/n8n-mcp-cc-buildier
docker compose down

# KROK 2: Pobierz najnowszy obraz n8n
docker pull n8nio/n8n:latest

# KROK 3: Uruchom ponownie (użyje nowej wersji)
./scripts/start_servers.sh

# KROK 4: Sprawdź nową wersję
docker exec n8n-test n8n --version
```

**Co się stanie:**
```
Status: Downloaded newer image for n8nio/n8n:latest
LUB
Status: Image is up to date (jeśli już najnowsza)
```

### Aktualizuj do konkretnej wersji

```bash
# KROK 1: Edytuj docker-compose.yml
nano docker-compose.yml

# KROK 2: Zmień linię:
# BYŁO:  image: n8nio/n8n:latest
# BĘDZIE: image: n8nio/n8n:1.72.0  (przykład konkretnej wersji)

# KROK 3: Zatrzymaj i uruchom ponownie
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

```bash
# Jeśli zmienił się docker-compose.yml
docker compose down
./scripts/start_servers.sh
```

---

## 4. 🔄 Aktualizacja n8n-mcp (lokalny npm)

### Sprawdź obecną wersję

```bash
npx n8n-mcp --version
# Przykład: 1.0.0
```

### Aktualizuj

```bash
npm update -g n8n-mcp
```

### Sprawdź nową wersję

```bash
npx n8n-mcp --version
# Powinna być nowsza
```

### Po aktualizacji - restart Claude Desktop

```bash
# Zamknij Claude Desktop całkowicie
taskkill /F /IM "claude.exe"

# Uruchom ponownie z menu Start
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

```
1. Otwórz http://localhost:5678
2. Settings → Community Nodes
3. Kliknij "Install a community node"
4. Wpisz nazwę pakietu (np. n8n-nodes-telegram)
5. Kliknij "Install"
6. Restart n8n (docker compose restart)
```

#### SPOSÓB 2: Ręcznie (zaawansowane)

```bash
# Wejdź do kontenera n8n
docker exec -it n8n-test sh

# Zainstaluj node
npm install n8n-nodes-telegram

# Wyjdź
exit

# Restart kontenera
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

```
n8n UI → Settings → Community Nodes
→ Lista zainstalowanych nodes
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

```bash
# Backup wszystkiego
cp -r ~/.n8n-mcp-test ~/Backup/n8n-data-$(date +%Y%m%d)

# Windows (PowerShell):
Copy-Item -Recurse -Path "$env:USERPROFILE\.n8n-mcp-test" -Destination "$env:USERPROFILE\Backup\n8n-data-$(Get-Date -Format 'yyyyMMdd')"
```

**Zawiera:**
- ✅ Wszystkie workflow
- ✅ Credentials (zaszyfrowane)
- ✅ Execution history
- ✅ Settings

#### B) OPCJONALNIE - Projekt (skrypty)

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

```bash
# Zatrzymaj n8n
docker compose down

# Przywróć dane
cp -r ~/Backup/n8n-data-20241115/* ~/.n8n-mcp-test/

# Uruchom ponownie
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

**Sprawdź:**
```bash
# Logi n8n
docker logs n8n-test

# Czy Docker działa?
docker ps

# Czy port 5678 jest wolny?
lsof -i :5678  # macOS/Linux
netstat -ano | findstr :5678  # Windows
```

**Rozwiązanie:**
```bash
# Restart wszystkiego
docker compose down
docker compose up -d
```

### Problem: Claude Desktop nie widzi MCP tools

**Sprawdź:**
```bash
# Czy n8n-mcp jest zainstalowany?
npx n8n-mcp --version

# Sprawdź config
cat "$APPDATA/Claude/claude_desktop_config.json"
# (Windows PowerShell)
```

**Rozwiązanie:**
```bash
# Reinstall n8n-mcp
npm install -g n8n-mcp

# Restart Claude Desktop
taskkill /F /IM "claude.exe"
# Uruchom ponownie
```

### Problem: API key nie działa

**Objawy:**
```
MCP server initialized with 23 tools (n8n API: not configured)
```

**Rozwiązanie:**
```bash
# Sprawdź czy API key jest zapisany
cat ~/.n8n-mcp-test/.n8n-api-key

# Jeśli pusty - wygeneruj nowy w n8n UI
# http://localhost:5678 → Settings → API → Create API Key

# Zapisz nowy klucz
echo "NOWY_KLUCZ" > ~/.n8n-mcp-test/.n8n-api-key

# Restart
docker compose restart n8n-mcp
```

### Problem: Workflow nie działa po aktualizacji

**Możliwe przyczyny:**
1. Community node niekompatybilny z nową wersją n8n
2. Zmiana w API node'a
3. Zmiana w składni wyrażeń

**Rozwiązanie:**
1. Sprawdź execution history w n8n UI
2. Zobacz dokładny błąd
3. Zaktualizuj community nodes
4. Dopasuj konfigurację node'ów

---

## 📅 Rutynowa konserwacja (checklist)

### Co tydzień
- [ ] Sprawdź czy Docker Desktop ma aktualizacje
- [ ] Backup danych workflow (`~/.n8n-mcp-test`)

### Co miesiąc
- [ ] Aktualizuj n8n (`docker pull n8nio/n8n:latest`)
- [ ] Aktualizuj n8n-mcp (`npm update -g n8n-mcp`)
- [ ] Aktualizuj projekt (`git pull origin main`)
- [ ] Sprawdź czy community nodes są kompatybilne

### Przed każdą aktualizacją n8n
- [ ] Backup danych (`~/.n8n-mcp-test`)
- [ ] Sprawdź changelog n8n (https://github.com/n8n-io/n8n/releases)
- [ ] Sprawdź kompatybilność community nodes

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

**Ostatnia aktualizacja:** 2024-11-15
**Autor:** n8n-mcp-cc-buildier project
