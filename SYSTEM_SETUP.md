# 🖥️ Moja Konfiguracja Systemu - Punkt Wyjścia

> **Cel:** Ten dokument opisuje moją pełną konfigurację systemu do pracy z MCP servers (n8n-mcp, Notion MCP, itp.)
>
> **Użycie:** Załącz ten plik do nowych sesji Claude, aby Claude rozumiał Twoją infrastrukturę.

---

## 📋 Specyfikacja Systemu

### System Operacyjny
- **OS:** Windows 11
- **Terminal:** Git Bash (preferowany), PowerShell (alternatywa)
- **Ścieżka użytkownika:** `C:\Users\mstrz`

### Zainstalowane Narzędzia

| Narzędzie | Wersja | Lokalizacja | Status |
|-----------|--------|-------------|--------|
| **Docker Desktop** | Latest | Docker Desktop app | ✅ Zainstalowany |
| **Node.js** | v24.11.1 | `C:\Program Files\nodejs\` | ✅ Zainstalowany |
| **npm** | Latest | Z Node.js | ✅ Zainstalowany |
| **Git** | Latest | `C:\Program Files\Git\` | ✅ Zainstalowany |
| **Git Bash** | Z Git | Git Bash terminal | ✅ Aktywny |
| **Claude Desktop** | Latest | `%LOCALAPPDATA%\Programs\Claude\` | ✅ Zainstalowany |

---

## 📁 Struktura Folderów

### Projekt n8n-mcp-cc-buildier
```
C:\users\mstrz\onedrive\dokumenty\docker\n8n-mcp-cc-buildier\
├── docker-compose.yml          # Konfiguracja Docker (n8n + n8n-mcp-server)
├── scripts/
│   ├── start_servers.sh       # Start n8n + n8n-mcp-server
│   └── test-n8n-integration.sh
├── .claude/
│   └── agents/                # Konfiguracja 7 agentów n8n
├── CLAUDE.md                  # Instrukcje dla Claude Code
├── MAINTENANCE_GUIDE.md       # Przewodnik konserwacji (PL)
└── SYSTEM_SETUP.md           # Ten dokument (kontekst systemu)
```

### Dane n8n (persystentne)
```
C:\Users\mstrz\.n8n-mcp-test\
├── database.sqlite           # Wszystkie workflow (SQLite)
├── .n8n/
│   ├── credentials/          # API keys (zaszyfrowane)
│   └── nodes/               # Community nodes (jeśli zainstalowane)
├── .n8n-api-key             # JWT token dla n8n API
└── executions/              # Historia wykonań workflow
```

### n8n-mcp (npm globalny)
```
C:\Users\mstrz\AppData\Roaming\npm\node_modules\n8n-mcp\
└── (kod n8n-mcp)
```

### Claude Desktop - konfiguracja MCP
```
%APPDATA%\Claude\claude_desktop_config.json
```

---

## 🔧 Aktualna Konfiguracja MCP

### Claude Desktop Config (`claude_desktop_config.json`)

```json
{
  "mcpServers": {
    "n8n-mcp": {
      "command": "npx",
      "args": [
        "n8n-mcp"
      ],
      "env": {
        "MCP_MODE": "stdio",
        "N8N_API_URL": "http://localhost:5678/api/v1",
        "N8N_API_KEY": "eyJhbGci...***COMPLETE_JWT_TOKEN***...yZZs"
      }
    }
  },
  "preferences": {
    "menuBarEnabled": true
  }
}
```

**Uwagi:**
- ✅ Używam **lokalnego npm** (`npx n8n-mcp`), NIE Docker exec
- ✅ API Key jest JWT format (zaczyna się od `eyJhbGci...`)
- ✅ URL wskazuje na `http://localhost:5678/api/v1` (lokalny n8n)
- ✅ MCP_MODE: `stdio` (standard input/output)

---

## 🔑 API Keys i Credentials

### n8n API Key (JWT)
- **Format:** `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWI...` (JWT token)
- **Lokalizacja zapisana:**
  - `C:\Users\mstrz\.n8n-mcp-test\.n8n-api-key`
  - `%APPDATA%\Claude\claude_desktop_config.json` (sekcja `N8N_API_KEY`)
- **Wygenerowany w:** n8n UI → Settings → API → Create API Key
- **Status:** ✅ Aktywny i działający

### Inne credentials
- **n8n credentials:** Zapisane w `~/.n8n-mcp-test/.n8n/credentials/` (zaszyfrowane)
- **Claude widzi:** Tylko ID/nazwy credentials, nigdy faktyczne klucze

---

## 🚀 Procedury Operacyjne

### Sekwencja Startowa (po restarcie komputera)

#### KROK 1: Docker Desktop
```bash
# Uruchom Docker Desktop (kliknij ikonę)
# Poczekaj aż ikona przestanie migać (Docker ready)

# Sprawdź czy działa:
docker ps
```

#### KROK 2: n8n + n8n-mcp-server
```bash
# W Git Bash:
cd /c/users/mstrz/onedrive/dokumenty/docker/n8n-mcp-cc-buildier
./scripts/start_servers.sh

# Oczekiwany output:
# ✅ Docker is installed
# ✅ Docker Compose is installed
# ✅ n8n is ready!
# ✅ MCP server is ready!
# 🎉 Both services are running!
```

#### KROK 3: Claude Desktop
```bash
# Uruchom z menu Start
# MCP n8n-mcp połączy się automatycznie (lokalny npx)
# Sprawdź w Chat: powinno pokazać 42 n8n-mcp tools
```

### Zamykanie Claude Desktop

**Git Bash:**
```bash
taskkill.exe /IM "Claude.exe" /F
```

**PowerShell:**
```powershell
taskkill /IM "Claude.exe" /F
```

**Ręcznie:**
- System tray (ikony przy zegarze) → prawy przycisk na Claude → Exit

### Restart Claude Desktop

```bash
# 1. Zamknij
taskkill.exe /IM "Claude.exe" /F

# 2. Poczekaj 5 sekund
sleep 5

# 3. Uruchom z menu Start (ręcznie)
```

### Sprawdzanie Statusu

**n8n działa?**
```bash
curl http://localhost:5678/healthz
# Lub otwórz w przeglądarce: http://localhost:5678
```

**Docker kontenery działają?**
```bash
docker ps
# Powinny być 2 kontenery:
# - n8n-test (port 5678)
# - n8n-mcp-server
```

**MCP tools widoczne?**
```
Claude Desktop → Chat → "Czy widzisz narzędzia n8n-mcp?"
# Powinno pokazać: 42 tools available
```

**Test API n8n (PowerShell):**
```powershell
$apiKey = "TWÓJ_API_KEY"
curl.exe -X GET "http://localhost:5678/api/v1/workflows" -H "X-N8N-API-KEY: $apiKey"
# Powinno zwrócić: {"data":[...]...}
```

---

## 🐳 Docker Compose - Serwisy

### n8n (Workflow Platform)
```yaml
services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n-test
    ports:
      - "5678:5678"
    volumes:
      - ${HOME}/.n8n-mcp-test:/home/node/.n8n
    environment:
      - N8N_BASIC_AUTH_ACTIVE=false
      - N8N_HOST=localhost
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
```

### n8n-mcp-server (MCP Server - backup)
```yaml
  n8n-mcp:
    image: ghcr.io/czlonkowski/n8n-mcp:latest
    container_name: n8n-mcp-server
    environment:
      - N8N_API_KEY=${N8N_API_KEY}
      - N8N_API_URL=http://n8n:5678/api/v1
```

**Uwaga:** n8n-mcp-server to **backup**. Claude Desktop używa **lokalnego npm** (`npx n8n-mcp`).

---

## 🎯 Zainstalowane MCP Servers

### n8n-mcp ✅
- **Status:** Zainstalowany i działający
- **Metoda:** npm globalny (`npm install -g n8n-mcp`)
- **Wywołanie:** `npx n8n-mcp`
- **Tools:** 42 narzędzia n8n (workflow management, node discovery, validation)
- **Połączenie:** Lokalny n8n (http://localhost:5678)

### n8n-skills ✅
- **Status:** 5 skills zainstalowanych
- **Lokalizacja:** `%APPDATA%\Roaming\Claude\skills\`
- **Skills:**
  1. n8n-expression-syntax (11 KB)
  2. n8n-mcp-tools-expert (15 KB)
  3. n8n-workflow-patterns (35 KB)
  4. n8n-validation-expert (18 KB)
  5. n8n-node-configuration (17 KB)
- **Token usage:** ~2-6K tokenów każdy (~10% z 200K context window dla wszystkich 5)

### Inne MCP (do zainstalowania)
- **Notion MCP:** ❌ Planowane
- **GitHub MCP:** ❌ Opcjonalne
- **Filesystem MCP:** ❌ Opcjonalne

---

## 📝 Notatki dla Claude w Nowych Sesjach

### Kiedy instalujesz nowy MCP Server (np. Notion):

1. **Gdzie dodać konfigurację:**
   ```
   %APPDATA%\Claude\claude_desktop_config.json
   ```
   W sekcji `mcpServers` dodaj nowy wpis obok `n8n-mcp`.

2. **Format instalacji (preferowany):**
   ```json
   {
     "mcpServers": {
       "n8n-mcp": { ... },  // ← Istniejący
       "notion": {          // ← Nowy
         "command": "npx",
         "args": ["-y", "@notionhq/notion-mcp-server"],
         "env": {
           "NOTION_TOKEN": "ntn_***"
         }
       }
     }
   }
   ```

3. **Po edycji config zawsze:**
   ```bash
   # Zamknij Claude całkowicie
   taskkill.exe /IM "Claude.exe" /F

   # Poczekaj 5 sekund
   sleep 5

   # Uruchom ponownie
   ```

4. **Moja preferencja:**
   - ✅ **npm globalny** (`npx` w config) - preferowany
   - ✅ **Docker** - tylko jeśli npm nie działa
   - ❌ **Smithery** - nie używam (wolę ręczną kontrolę)

### Kiedy debugujesz problemy MCP:

1. **Test API bezpośrednio (dla n8n):**
   ```powershell
   $apiKey = "eyJhbGci..."
   curl.exe -X GET "http://localhost:5678/api/v1/workflows" -H "X-N8N-API-KEY: $apiKey"
   ```

2. **Sprawdź logi Claude Desktop:**
   ```
   %APPDATA%\Claude\logs\
   ```

3. **Sprawdź czy MCP package zainstalowany:**
   ```bash
   npm list -g n8n-mcp
   # Lub dla Notion:
   npm list -g @notionhq/notion-mcp-server
   ```

4. **Typowe problemy:**
   - ❌ Claude Desktop nie zrestartowany → użyj `taskkill /F`
   - ❌ Spacje w API key → usuń spacje z config
   - ❌ Stary API key → wygeneruj nowy w serwisie (n8n/Notion/etc.)
   - ❌ Port zajęty → sprawdź `netstat -ano | findstr :5678`

---

## 🔄 Historia Zmian w Konfiguracji

### 2024-11-15: Initial Setup
- ✅ Zainstalowano Docker Desktop
- ✅ Zainstalowano Node.js v24.11.1 (+ Python, vcredist, VS Build Tools przez Chocolatey)
- ✅ Zainstalowano n8n-mcp globalnie (npm)
- ✅ Skonfigurowano Claude Desktop z lokalnym npx n8n-mcp
- ✅ Zainstalowano 5 n8n-skills

### 2024-11-15: Migracja z Docker exec → npx
- **Problem:** Docker exec generował JSON parsing errors w Claude Desktop
- **Próby naprawy:** `mcp-wrapper.cmd` z `2>nul` (nie zadziałało)
- **Rozwiązanie:** Przejście na lokalny `npx n8n-mcp` (eliminuje logi Docker)
- **Rezultat:** ✅ Brak błędów, pełne 42 tools widoczne

### 2024-11-15: API Key Update
- **Problem:** Builder pokazywał błąd autoryzacji
- **Diagnoza:** Config miał stary API key (krótszy JWT)
- **Rozwiązanie:** Zaktualizowano do aktualnego key z n8n Settings → API
- **Rezultat:** ✅ API działa poprawnie (`curl` test OK)

---

## 📚 Dokumentacja Projektu

### Gdzie szukać pomocy:

| Dokument | Opis | Lokalizacja |
|----------|------|-------------|
| **SYSTEM_SETUP.md** | Ten plik - kontekst systemu | `n8n-mcp-cc-buildier/` |
| **MAINTENANCE_GUIDE.md** | Przewodnik konserwacji (PL) | `n8n-mcp-cc-buildier/` |
| **CLAUDE.md** | Instrukcje dla Claude Code | `n8n-mcp-cc-buildier/` |
| **README.md** | Opis projektu (GitHub) | `n8n-mcp-cc-buildier/` |

### Linki zewnętrzne:
- n8n docs: https://docs.n8n.io
- n8n-mcp: https://www.n8n-mcp.com
- Projekt GitHub: https://github.com/fundacjafutureminds/n8n-mcp-cc-buildier

---

## ✅ Checklist dla Nowych Sesji Claude

Kiedy startujesz nową sesję i załączasz ten dokument, Claude powinien wiedzieć:

- [x] Pracuję na **Windows 11** z **Git Bash**
- [x] Mam **Docker Desktop** + **n8n** na porcie **5678**
- [x] Używam **lokalnego npm** dla n8n-mcp (NIE Docker exec)
- [x] Mój config MCP jest w `%APPDATA%\Claude\claude_desktop_config.json`
- [x] API key n8n to JWT format (działa poprawnie)
- [x] Po edycji config muszę **całkowicie zamknąć** Claude (`taskkill /F`)
- [x] Preferuję **npm globalny** dla nowych MCP servers
- [x] Dane n8n są w `~/.n8n-mcp-test` (oddzielnie od projektu)

---

**Ostatnia aktualizacja:** 2024-11-15
**Branch:** `claude/explain-m-01Nnye51qQBjDNhb3CWujYtv`
**Wersja:** 1.0
**Autor:** Wypracowane wspólnie w sesji n8n-mcp-cc-buildier installation
