# Unbound — Comprehensive Project Architecture & Context Memory

> **Document Version:** 2.2.0  
> **Last Updated:** 2026-10-14T18:25 IST  
> **Target Audience:** Any AI Agent or Developer continuing development on Unbound.  
> **Status:** Fully portable and verified full-stack application (Zero analyzer errors across backend, client, and frontend; one-click launcher `start_app.ps1` validated for any Windows laptop).

---

## 1. Executive Summary & Architecture

**Unbound** is an intelligent, high-performance productivity workstation combining:
1. **Interactive Mind Mapping**: Infinite 2D visual node canvas with Bezier curves, custom node editing, templates, and AI generation.
2. **AI Document & Text Insights**: Extractive & generative summarization with PDF ingestion, key points, action items, and task extraction.
3. **Smart Task & Schedule Prioritizer**: Urgency-weighted scheduling, conflict-free auto-rescheduling, and daily AI productivity guidance.
4. **Smart Notes & Voice Commands**: Dictation, intent classification (note vs. task), and multi-modal capture.
5. **Full Authentication & Interactive Dashboard**: User registration/login with hashed credentials, session persistence, productivity progress gauges, interactive checklists, and live metrics.

### Technology Stack
| Layer | Technology | Version | Purpose |
| :--- | :--- | :--- | :--- |
| **Backend Framework** | Serverpod (Dart) | 4.0.4 | High-performance ORM, RPC endpoints, code generator |
| **Backend Language** | Dart SDK | 3.13.5 | Monolithic server running on ports 8080, 8081, 8082 |
| **Frontend Framework** | Flutter | Latest Stable (Channel stable) | Cross-platform UI (Web, Desktop, Mobile) |
| **Frontend Design** | Material Design 3 | MD3 | Vibrant gradients, dark mode, responsive layout |
| **Primary Database** | PostgreSQL | Native Windows install (port 5432) | Relational data persistence with auto-migrations |
| **AI / LLM Tier 1** | OpenAI API (`gpt-4o-mini`) | `v1/chat/completions` | Generative summarization and intent extraction |
| **AI / LLM Tier 2** | Google Gemini (`gemini-2.0-flash`)| Gemini REST API | Ultra-fast fallback when OpenAI hits quota limits |
| **AI / LLM Tier 3** | Offline Rule-Based Engines | Pure Dart | Zero-latency extractive summarizer, regex intent parser |

---

## 2. Workspace Organization & Sync Workflow

There are two primary project folders on this machine:

### A. `C:\unbond\` (Primary Working Source & Versioned Code)
This is the root workspace where edits are authored. All code changes must be saved here first.
```
C:\unbond\
├── PROJECT_HANDOFF.md             # THIS FILE (Master Project Memory)
├── README_FIRST.txt               # Instructions on syncing unbond to mindmap_ai
├── mindmap_ai_flutter\            # Flutter Frontend Codebase
│   └── lib\
│       ├── core\                  # API client, Auth state, UI formatters
│       ├── screens\               # 7 App Screens (Auth, Home, MindMap, Notes, Tasks, Insights, Voice)
│       ├── services\              # PDF Document picker, Speech recognition
│       ├── widgets\               # Summary view, task forms, state views
│       └── main.dart              # App bootstrap & 6-tab navigation
└── mindmap_ai_server\             # Serverpod Backend Codebase
    ├── config\                    # passwords.example.yaml
    └── lib\src\
        ├── endpoints\             # User, AI, MindMaps, Notes, Tasks, Preferences RPCs
        ├── models\                # .spy.yaml Serverpod models
        └── services\              # LLM client, Fallback engines, Prioritizer, Scheduler
```

### B. `C:\mindmap_ai\` (Active Runtime Deployment Directory)
This is where the currently running Serverpod server, PostgreSQL migrations, and Flutter live build run from.
```
C:\mindmap_ai\
├── mindmap_ai_client\             # Generated Serverpod client package
├── mindmap_ai_server\             # Live server execution folder
│   ├── config\passwords.yaml      # REAL API keys & DB passwords (NEVER COMMIT)
│   ├── migrations\                # Serverpod migration folders
│   └── bin\main.dart              # Server executable
└── mindmap_ai_flutter\            # Live Flutter runner folder
```

### Critical Sync Protocol:
Whenever you modify files in `C:\unbond\`, copy them over to `C:\mindmap_ai\` using PowerShell:
```powershell
Copy-Item -Path "c:\unbond\mindmap_ai_server\*" -Destination "c:\mindmap_ai\mindmap_ai_server\" -Recurse -Force
Copy-Item -Path "c:\unbond\mindmap_ai_flutter\*" -Destination "c:\mindmap_ai\mindmap_ai_flutter\" -Recurse -Force
```

---

## 3. Server Configuration & Ports

| Service | Port | Description |
| :--- | :--- | :--- |
| **Serverpod API** | `8080` | Flutter app talks to this RPC endpoint |
| **Serverpod Insights** | `8081` | Web admin, diagnostics, health metrics |
| **Serverpod Web** | `8082` | Built-in web server |
| **PostgreSQL** | `5432` | Native Windows database service (`mindmap_ai` DB) |

### API Keys Configuration (`C:\mindmap_ai\mindmap_ai_server\config\passwords.yaml`)
```yaml
shared:
  openAiApiKey: 'sk-proj-...'       # Primary LLM provider
  geminiApiKey: 'AQ.Ab8RN6K...'     # Secondary LLM provider (Gemini 2.0 Flash)

development:
  database: 'postgres'              # PostgreSQL password for user postgres
```

> [!NOTE]
> The Gemini API key begins with `AQ.`, which is a valid Google AI Studio key format.

---

## 4. Multi-Tier AI Engine & Critical Architecture Fixes

### The 3-Tier Robust AI Architecture
In `mindmap_ai_server/lib/src/services/llm_client.dart`:
```
   User Request (Summarize / Voice / MindMap / Suggestion)
                         │
                         ▼
             [ Tier 1: OpenAI gpt-4o-mini ]
                         │
                 (If 429 Rate Limit / Quota Exceeded / Error)
                         ▼
             [ Tier 2: Gemini 2.0 Flash ]
                         │
                 (If Network Failure / No API Key / Timeout)
                         ▼
     [ Tier 3: Deterministic Offline Rule-Based Parsers ]
             ├── SummaryFallbackParser (Extractive text analysis)
             ├── VoiceFallbackParser (Regex intent & entities)
             ├── AiParsers.mindMapFallback (Hierarchical graph builder)
             └── SuggestionService.ruleBased (Urgency heuristics)
```

### The Critical `AppException` vs `LlmException` Bug & Solution
- **The Bug:** When OpenAI returned 429 quota errors, the server sent `AppException: The AI service is busy. Please try again.` back to the client immediately, **bypassing the endpoint's `try/catch` and fallback logic**.
- **Root Cause:** In Serverpod 4.0.4, classes extending `SerializableModel` or defined in `.spy.yaml` as exceptions (like `AppException`) are intercepted at the framework level inside `Server._handleEndpointCall` as protocol errors and serialized directly to the client.
- **The Solution:** Created a native Dart exception in `llm_client.dart`:
  ```dart
  class LlmException implements Exception {
    final String message;
    final int? statusCode;
    const LlmException(this.message, {this.statusCode});
    @override
    String toString() => 'LlmException: $message';
  }
  ```
  Because `LlmException` is a plain Dart exception (not a Serverpod model), Serverpod does not intercept it. The endpoint catch blocks smoothly intercept it and activate Tier 2 (Gemini) or Tier 3 (Offline fallback).

---

## 5. Application Screens & Features

The Flutter app (`mindmap_ai_flutter/lib/main.dart`) is structured as a single-page app with 6 navigation destinations and an authentication wrapper:

```
                      [ AuthGate: AuthStateListener ]
                                     │
           ┌─────────────────────────┴─────────────────────────┐
           ▼                                                   ▼
   [ Unauthenticated ]                                 [ Authenticated ]
     AuthScreen (Sign In / Register)                     MainTabController (6 Tabs)
                                                         ├── Tab 0: Home / Dashboard
                                                         ├── Tab 1: Visual Mind Map
                                                         ├── Tab 2: Smart Notes
                                                         ├── Tab 3: Tasks & Scheduling
                                                         ├── Tab 4: AI Insights
                                                         └── Tab 5: Voice Assistant
```

### Tab 0: Interactive Dashboard (`home_screen.dart`)
- **Greeting & Time Dynamic Banner**: Morning/Afternoon/Evening dynamic greeting with live date.
- **Productivity Progress Gauge**: Circular/linear progress indicator calculating completed tasks vs. total tasks for today.
- **Live Stats Cards**: Notes count, Pending Tasks, Completed Tasks, Mind Maps count.
- **AI Daily Focus Card**: "What should I do next?" with a one-tap live refresh button.
- **Quick Action Hub**: 1-tap shortcuts to open Voice Note, Create Task dialog, Create Mind Map, or New Note.
- **Live Interactive Checklist**: Checkboxes for tasks directly from the home screen without navigating away.
- **Recent Notes Carousel**: Horizontal preview of recently modified notes.

### Tab 1: Visual Mind Map Canvas (`mindmap_screen.dart`)
- **Interactive Infinite Canvas**: Custom-rendered node graph with pan, zoom, and fit-to-screen controls.
- **Node Management**: Add child nodes, sibling nodes, edit titles, change node colors, delete branches.
- **Bezier Connector Lines**: Smooth curved lines between parent and child nodes.
- **Pre-Built Templates**: Brainstorming, Project Roadmap, Weekly Planning, System Architecture.
- **AI Mind Map Generation**: Type any prompt/topic (e.g. "Quantum Computing Basics") to generate a complete visual tree via LLM or offline fallback.
- **Database Persistence**: Full JSON graph stored in PostgreSQL via `MindMapsEndpoint`.

### Tab 2: Smart Notes (`notes_screen.dart`)
- List of notes with title, creation date, summary snippet, and sparkle indicator for AI-processed notes.
- **NoteEditorScreen**: Full text editor with:
  - Text input & auto-save
  - One-tap AI Summarize
  - Audio dictation trigger
  - Conversion of AI-extracted action items into linked Tasks.

### Tab 3: Tasks & Scheduling (`tasks_screen.dart`)
- Segmented filter: `Pending` vs `Completed`.
- Task priority chips: `High` (Red), `Medium` (Orange), `Low` (Green).
- Overdue task warning system with inline **"Suggest new time"** button.
- **Conflict-Free Rescheduler**: Server queries existing tasks and user working hours (`UserPreferences`) to propose open time slots.

### Tab 4: AI Insights & Document Summarizer (`insights_screen.dart`)
- **PDF & Document Ingestion**: Ingests `.pdf` or raw text via `document_picker.dart`.
- **Structured Output**: Summaries include:
  - TL;DR executive summary
  - Bulleted Key Points
  - Extracted Action Items
  - Suggested Tasks (with 1-click import into task manager)
- **AI Voice Explanation & Audio Briefing**:
  - One-tap **"Explain with Voice"** action in `SummaryView` and `InsightsScreen`.
  - Automatically synthesizes a conversational audio narrative of the summary, key points, and action items via `TtsService`.
  - Interactive **`VoiceExplanationPlayer`** with animated equalizer waves and Play/Pause/Stop controls.
  - **5 AI Voice Personas**: 3 Females (**Aria** - Clear & Executive, **Serena** - Calm & Soothing, **Nova** - Dynamic & Upbeat) and 2 Males (**Marcus** - Deep & Authoritative, **Leo** - Warm & Conversational).
  - **Configurable Playback Speeds**: Slower (`0.25x`, `0.5x`), Normal (`1.0x`), Faster (`1.25x`, `1.5x`, `2.0x`).
  - Expandable spoken script reader.
- **Clickable Saved Summaries**: History of previous summaries; clicking opens the full note in `NoteEditorScreen`.
- **AI Recommended Priorities**: Top 3 algorithmic priorities surfaced from the backend.

### Tab 5: Voice Assistant (`voice_screen.dart`)
- Web speech recognition integration.
- Dictation with automatic punctuation.
- **Intent Recognition**: Classifies speech into Note or Task, extracts date/time references ("tomorrow at 3pm"), priority ("urgent"), and duration ("30 minutes").
- Interactive confirmation card before saving to database.

---

## 6. Authentication & Session Architecture

### Server Layer (`user_endpoint.dart`)
- **Model**: `UserAccount` (`user_account.spy.yaml`)
  - `email` (String, unique)
  - `passwordHash` (SHA-256 with salt)
  - `displayName` (String)
  - `createdAt` (DateTime)
- **Methods**:
  - `register(email, password, displayName)`
  - `login(email, password)`
  - `getDashboardStats()`
  - `getProfile()`

### Client Layer (`auth_state.dart` & `auth_screen.dart`)
- `AuthManager` singleton using `ChangeNotifier` and `shared_preferences`.
- Automatically restores user session on app refresh.
- Quick-fill demo account button for instant testing.
- Sign out clears local cache and resets navigation to `AuthScreen`.

---

## 7. Database Models & Migrations

All models are specified in `mindmap_ai_server/lib/src/models/*.spy.yaml`:

| Model File | Table Name | Purpose |
| :--- | :--- | :--- |
| `user_account.spy.yaml` | `user_account` | User credentials & profile |
| `mind_map.spy.yaml` | `mind_map` | Canvas graph data (JSON nodes & links) |
| `note.spy.yaml` | `note` | Notes content, title, AI summary |
| `task.spy.yaml` | `task` | Title, status, priority, due date, duration |
| `user_preferences.spy.yaml` | `user_preferences` | Workday start/end, break duration, timezone |
| `summary_result.spy.yaml` | *(unbound)* | DTO for AI summary results |
| `voice_command_result.spy.yaml` | *(unbound)* | DTO for voice parse results |
| `daily_suggestion.spy.yaml` | *(unbound)* | DTO for daily productivity advice |

### Migrations History:
1. `20261013061608059` — Initial baseline schema (`note`, `task`, `user_preferences`)
2. `20261013071500070` — Added `sourceNoteId` and scheduling fields to `task`
3. `20261014052145698` — Added `user_account` table for authentication
4. `20261014054231717` — Added `mind_map` table for visual graph persistence

---

## 8. Complete Server Endpoint Reference

### 1. `UserEndpoint`
- `register(email, password, displayName)` -> `AuthResponse`
- `login(email, password)` -> `AuthResponse`
- `getDashboardStats()` -> `DashboardStats`
- `getProfile()` -> `UserAccount?`

### 2. `AiEndpoint`
- `summarizeText(text)` -> `SummaryResult`
- `processVoiceCommand(text)` -> `VoiceCommandResult`
- `getDailySuggestion()` -> `DailySuggestion`
- `generateMindMap(topic)` -> `String` (JSON graph structure)

### 3. `MindMapsEndpoint`
- `createMindMap(title, description, graphJson)` -> `MindMap`
- `getMindMaps()` -> `List<MindMap>`
- `getMindMap(id)` -> `MindMap?`
- `updateMindMap(id, title, graphJson)` -> `MindMap`
- `deleteMindMap(id)` -> `void`

### 4. `NotesEndpoint`
- `createNote(title, content)` -> `Note`
- `getNotes()` -> `List<Note>`
- `updateNote(id, title, content, {summary})` -> `Note`
- `deleteNote(id)` -> `void`

### 5. `TasksEndpoint`
- `createTask(title, priority, durationMinutes, {dueAt, sourceNoteId})` -> `Task`
- `getTasks({status})` -> `List<Task>`
- `getOverdueTasks()` -> `List<Task>`
- `getPrioritizedTasks({limit})` -> `List<Task>`
- `updateTask(id, {status, dueAt})` -> `Task`
- `deleteTask(id)` -> `void`
- `suggestReschedule(taskId)` -> `RescheduleProposal?`
- `rescheduleTask(taskId, newStart)` -> `Task`

### 6. `PreferencesEndpoint`
- `getPreferences()` -> `UserPreferences`
- `savePreferences(workStart, workEnd, breakMin, tz, offsetMin)` -> `UserPreferences`

---

## 9. Operations, Running & Debugging Guide

### How to Check Database Status
PostgreSQL runs as a native Windows service. Verify it is running:
```powershell
Get-Service -Name postgresql* | Select-Object Name, Status
# Or check port 5432:
Get-NetTCPConnection -LocalPort 5432 -ErrorAction SilentlyContinue
```

### How to Run the Server
```powershell
cd C:\mindmap_ai\mindmap_ai_server
dart run bin/main.dart --apply-migrations
```
*Expected log output:*
```
Insights server: listening on http://localhost:8081
API server: listening on http://localhost:8080
Web server: listening on http://localhost:8082
```

### How to Run the Frontend
```powershell
cd C:\mindmap_ai\mindmap_ai_flutter
flutter run -d chrome
```

### Troubleshooting Common Issues

| Symptom | Cause | Solution |
| :--- | :--- | :--- |
| **"Failed to start the Serverpod servers"** | Port 8080/8081/8082 already in use by a previous instance | Find process: `Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess -ErrorAction SilentlyContinue \| Stop-Process -Force` |
| **"The AI service is busy"** | Serverpod intercepted `AppException` | Fixed by `LlmException` in `llm_client.dart`. Ensure server was restarted with latest code |
| **"CPU/memory metrics not supported"** | Windows OS limitation in Serverpod system monitoring | Normal and harmless; ignore on Windows |
| **Changes in `c:\unbond` not visible in app** | Running app runs from `c:\mindmap_ai` | Run file copy script to sync changes from `c:\unbond` to `c:\mindmap_ai` |

---

## 10. Next Milestone Priorities (Recommended Roadmap)

For any continuing agent, the following high-impact features are prioritized:

1. **User Data Isolation (`userId` filtering)**:
   - *Current state:* Notes, Tasks, and MindMaps are global across all accounts.
   - *Action:* Add `userId` (int, nullable/foreign key) to `note.spy.yaml`, `task.spy.yaml`, and `mind_map.spy.yaml`. Update queries in endpoints to filter by session user ID.
2. **Global Search & Tagging**:
   - Universal search across Notes, Tasks, and MindMap nodes with `#tags` (e.g. `#work`, `#finance`).
3. **Calendar Integration & Notifications**:
   - Push notification reminders for deadlines and export to `.ics` format.
4. **Rich Text / Markdown Note Editor**:
   - Upgrade `NoteEditorScreen` to support real-time Markdown preview and checkboxes.
5. **Realtime Collaboration / Export**:
   - Export Mind Maps as SVG, PNG, or JSON; export summaries as Markdown or PDF.

---
*Created by Antigravity Agent. All rights reserved.*
