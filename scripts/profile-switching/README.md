# 🔄 Profile Switching Scripts for Claude Desktop MCP

## Cel

Te skrypty PowerShell pozwalają na szybkie przełączanie między profilami MCP w Claude Desktop, redukując token overhead z ~228 tools (~25-30K tokenów) do ~77 tools (~6-8K tokenów).

## Struktura Profili

### 🏢 Profil WOJAK
- **n8n**: wojakproperties.app.n8n.cloud
- **Notion**: workspace wojakproperties
- **Airtable**: wojakproperties

### 🏛️ Profil FUNDACJA
- **n8n**: aneta175-20175.wykr.es
- **Notion**: workspace futureminds
- **Airtable**: WYŁĄCZONY (usuwa airtable-current z config)

### 🏠 Profil LOCALHOST
- **n8n**: localhost:5678 (Docker lokalny)
- **Notion**: workspace wojakproperties
- **Airtable**: wojakproperties

## Instalacja

### ⚠️ WAŻNE: Te skrypty są SZABLONAMI

**Pliki w tym repo zawierają placeholdery zamiast prawdziwych API keys** (ze względów bezpieczeństwa). Musisz je **skustomizować** przed użyciem!

### KROK 1: Skopiuj skrypty do folderu użytkownika

```powershell
# W PowerShell:
$source = ".\scripts\profile-switching"
$dest = "C:\Users\TWOJA_NAZWA_UŻYTKOWNIKA"  # ← Zmień na swoją nazwę!

Copy-Item "$source\switch-profile.ps1" $dest
Copy-Item "$source\wojak.ps1" $dest
Copy-Item "$source\fundacja.ps1" $dest
Copy-Item "$source\localhost.ps1" $dest
Copy-Item "$source\create-shortcuts.ps1" $dest
```

### KROK 1.5: ✏️ SKUSTOMIZUJ CREDENTIALS (WYMAGANE!)

Otwórz `C:\Users\TWOJA_NAZWA\switch-profile.ps1` w edytorze tekstu i **zastąp placeholdery** swoimi prawdziwymi kluczami:

```powershell
$profiles = @{
    'wojak' = @{
        n8n_url = 'https://YOUR-WOJAK-INSTANCE.app.n8n.cloud/api/v1'  # ← Twój URL
        n8n_key = 'YOUR_WOJAK_N8N_API_KEY_HERE'  # ← Twój n8n API key
        notion_token = 'YOUR_WOJAK_NOTION_TOKEN_HERE'  # ← Twój Notion token
        airtable_key = 'YOUR_WOJAK_AIRTABLE_KEY_HERE'  # ← Twój Airtable key
        has_airtable = $true
    }
    # ... powtórz dla fundacja i localhost
}
```

**Gdzie znaleźć klucze:**
- **n8n API Key**: n8n UI → Settings → API → Create API Key
- **Notion Token**: https://www.notion.so/my-integrations → New integration → Copy token
- **Airtable Key**: https://airtable.com/create/tokens → Create token

### KROK 2: Upewnij się, że config ma tylko 3 serwery

Otwórz `%APPDATA%\Claude\claude_desktop_config.json` i sprawdź, czy masz TYLKO:
- `n8n-current`
- `notion-current`
- `airtable-current`

Jeśli masz stare serwery (np. `n8n-wojakproperties`, `notion-mstrzebicki`), **usuń je** przed użyciem skryptów!

### KROK 3: Utwórz skróty na pulpicie

W PowerShell:

```powershell
C:\Users\mstrz\create-shortcuts.ps1
```

To utworzy 3 ikony na pulpicie:
- 🏢 **Profil WOJAK**
- 🏛️ **Profil FUNDACJA**
- 🏠 **Profil LOCALHOST**

## Użycie

### Przełączanie profilu

Kliknij dwukrotnie w ikonę na pulpicie lub uruchom w PowerShell:

```powershell
# Przełącz na profil WOJAK
C:\Users\mstrz\wojak.ps1

# Przełącz na profil FUNDACJA
C:\Users\mstrz\fundacja.ps1

# Przełącz na profil LOCALHOST
C:\Users\mstrz\localhost.ps1
```

### Co się dzieje podczas przełączania?

1. ✅ **Modyfikuje** `claude_desktop_config.json`:
   - Zmienia `N8N_API_URL` i `N8N_API_KEY` w `n8n-current`
   - Zmienia `NOTION_TOKEN` w `notion-current`
   - Dodaje/usuwa/aktualizuje `airtable-current` w zależności od profilu

2. 🔄 **Zamyka Claude Desktop** (`taskkill /IM "Claude.exe" /F`)

3. ⏸️ **Czeka 2 sekundy** na pełne zamknięcie

4. 📢 **Wyświetla komunikat** z prośbą o ręczne uruchomienie Claude Desktop

## Struktura Plików

```
C:\Users\mstrz\
├── switch-profile.ps1       # Główny skrypt (NIE uruchamiaj bezpośrednio)
├── wojak.ps1                # Wrapper dla profilu WOJAK
├── fundacja.ps1             # Wrapper dla profilu FUNDACJA
├── localhost.ps1            # Wrapper dla profilu LOCALHOST
└── create-shortcuts.ps1     # Pomocnik do tworzenia ikon na pulpicie
```

## Oszczędności

| Metryka | PRZED | PO | Oszczędność |
|---------|-------|-----|-------------|
| **Serwery MCP** | 7-8 | 3 | -4 do -5 |
| **Tools dostępne** | ~159-228 | ~77 | -82 do -151 |
| **Token overhead** | ~18-30K | ~6-8K | **~15-20K tokenów/request** ✨ |

## Aktualizacja API Keys

Jeśli musisz zaktualizować API key lub token, edytuj `C:\Users\TWOJA_NAZWA\switch-profile.ps1`:

```powershell
$profiles = @{
    'wojak' = @{
        n8n_url = 'https://wojakproperties.app.n8n.cloud/api/v1'
        n8n_key = 'NOWY_API_KEY_TUTAJ'
        # ...
    }
}
```

## Troubleshooting

### Problem: Skrypt pokazuje błąd "execution of scripts is disabled"

**Rozwiązanie:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Problem: Claude Desktop nie restartuje się automatycznie

**Rozwiązanie:** Skrypt **celowo** nie uruchamia Claude Desktop automatycznie. Musisz uruchomić ręcznie z menu Start.

### Problem: Po przełączeniu wciąż widzę stare tools

**Rozwiązanie:**
1. Całkowicie zamknij Claude Desktop (sprawdź w Task Manager czy proces `Claude.exe` nie istnieje)
2. Poczekaj 5 sekund
3. Uruchom ponownie

### Problem: Profil FUNDACJA nie usuwa Airtable

**Rozwiązanie:** Sprawdź w `switch-profile.ps1` czy flaga `has_airtable` dla fundacja jest ustawiona na `$false`.

## Powiązane Dokumenty

- **SYSTEM_SETUP.md** - Pełna konfiguracja systemu i MCP servers
- **MAINTENANCE_GUIDE.md** - Przewodnik konserwacji projektu (PL)

## Historia

- **2024-12-16**: Utworzenie systemu profile-switching (token optimization)
- **Branch**: `claude/explain-m-01Nnye51qQBjDNhb3CWujYtv`
