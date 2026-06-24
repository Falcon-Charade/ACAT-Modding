# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Version 1 represents the **initial public baseline** of all functionality.

---

## [Unreleased]

### Added
- _Nothing yet_

### Changed
- _Nothing yet_

### Fixed
- _Nothing yet_

### Removed
- _Nothing yet_

---

## [1.0.0] – Initial Release

### Added
- **ACAT Core addon framework**
  - CBA-compatible addon definition
  - Centralised dependency and load-order management
  - Namespaced function registration for future expansion

- **Server and client initialisation pipeline**
  - Automatic execution via CBA Extended Event Handlers
  - Clear separation of server-only and client-only logic
  - Safe early-initialisation using `XEH_preInit`

- **Platoon Roster system**
  - Centralised roster orchestration
  - Player connection tracking
  - Join timestamp capture
  - Server-side RPT logging
  - Duplicate-execution protection

- **Spectator functionality**
  - Standalone spectate script
  - Eden-placeable Spectate module
  - Server-validated execution
  - Flexible unit targeting
  - Custom Eden icon

- **Zeus integration**
  - Zeus-only action registration
  - Curator-aware initialisation
  - Context-sensitive Zeus UI bindings
  - Runtime enable/disable support

- **Player interaction framework**
  - Centralised player action registration
  - Self-service utility actions
  - Extensible structure for dependent addons

- **Utility and admin scripts**
  - AFK handling
  - Player unstuck recovery
  - Player state manipulation utilities
  - Lightweight performance monitoring
  - Debug logging helpers

- **Editor support**
  - Custom Eden module category
  - Proper faction classification for ACAT modules
  - Consistent editor visibility and grouping

---

### Functions
- `ACAT_fnc_serverInit`
- `ACAT_fnc_clientInit`
- `ACAT_fnc_runPlatoonRoster`
- `ACAT_fnc_addSpectateModule`
- `ACAT_fnc_initZeusActions`
- `ACAT_fnc_registerZeusActions`
- `ACAT_fnc_registerPlayerActions`
- `ACAT_fnc_dbg`

---

### Scripts
- `platoonRoster.sqf` – Platoon roster tracking and role management
- `addSpectate.sqf` – Spectator mode logic
- `afk.sqf` – AFK state handling
- `stuck.sqf` – Player recovery utility
- `shbf.sqf` – Temporary player state manipulation
- `monitor.sqf` – Performance diagnostics

---

### Assets
- Custom Eden module icon for Spectate module

---

### Notes
- This is the **baseline release** of ACAT_Core.
- No breaking changes exist.
- All future versions will be documented as incremental changes from this point.
- Designed to act as a **shared dependency layer** for all ACAT addons.