# Unbound — Setup Guide

> Run this on any Windows laptop. The whole stack (backend + database + frontend) starts with one script.

---

## What you need installed

| Tool | Where to get it | Check |
|---|---|---|
| **Flutter SDK** (includes Dart) | https://docs.flutter.dev/get-started/install/windows | `flutter --version` |
| **Google Chrome** | https://www.google.com/chrome/ | Needed for web UI |

> **No PostgreSQL install required.** Serverpod bundles its own embedded database that downloads automatically on first run.

---

## Step 1 — Copy the project

Copy the entire `c:\unbond\` folder to the same path on the new laptop.
You can use a USB drive, ZIP, or network share. **Include everything inside.**

```
c:\unbond\
  mindmap_ai_server\    ← backend + embedded database files
  mindmap_ai_flutter\   ← Flutter app
  mindmap_ai_client\    ← generated client (do not edit)
  start_app.ps1         ← one-click launcher ← run this
  SETUP.md              ← this file
  pubspec.yaml          ← workspace root
```

> **Tip:** The `.serverpod\development\pgdata\` folder inside `mindmap_ai_server`
> contains your database. Copy it so your notes/tasks transfer too. If you want a fresh database, delete that folder — the server will recreate it.

---

## Step 2 — Add your AI key (optional but recommended)

Edit `mindmap_ai_server\config\passwords.yaml`:

```yaml
shared:
  geminiApiKey: 'PASTE_YOUR_REAL_KEY_HERE'
```

Get a **FREE** Gemini key (no credit card): https://aistudio.google.com/app/apikey

> The app works without a key using its built-in offline AI.

---

## Step 3 — Run

**Option A — Double-click (easiest)**
Right-click `start_app.ps1` → **Run with PowerShell**

**Option B — Terminal**
```powershell
cd c:\unbond
.\start_app.ps1
```

The script will:
1. Check Flutter is installed
2. Download all Dart packages
3. Start the backend (downloads embedded PostgreSQL on first run — ~1 min)
4. Open the app in Chrome at **http://localhost:8090**

---

## Troubleshooting

### "Cannot run scripts" (PowerShell execution policy)
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

### Flutter not found after installing
Close and reopen PowerShell — Flutter adds itself to PATH but only in new terminals.

### Port 8080 already in use
The script frees it automatically. If it fails, run:
```powershell
netstat -ano | findstr :8080
taskkill /PID <the-pid-shown> /F
```

### First run takes 2 minutes
Serverpod downloads its embedded PostgreSQL binary on first run. Subsequent starts are fast (<5 s).

### "Error connecting to server" in the app
Make sure the backend window is open and shows `Server started on port 8080`.
Then refresh the browser tab.

### "No AI features / offline mode"
Add a Gemini key to `mindmap_ai_server\config\passwords.yaml` and restart the backend.

---

## Running on two laptops at the same time (LAN mode)

By default the app connects to `localhost`. To use it from another machine on the same Wi-Fi:

1. Find the host laptop's IP: `ipconfig` → look for `IPv4 Address` (e.g. `192.168.1.10`)
2. On the **client** laptop, run:
   ```powershell
   cd c:\unbond\mindmap_ai_flutter
   flutter run -d chrome --web-port 8090 --dart-define=SERVER_URL=http://192.168.1.10:8080/
   ```
3. Make sure Windows Firewall allows port 8080 on the host laptop.

---

## Manual startup (without the script)

**Terminal 1 — Backend:**
```powershell
cd c:\unbond\mindmap_ai_server
dart run bin/main.dart --apply-migrations
```

**Terminal 2 — Frontend:**
```powershell
cd c:\unbond\mindmap_ai_flutter
flutter run -d chrome --web-port 8090 --dart-define=SERVER_URL=http://localhost:8080/
```
