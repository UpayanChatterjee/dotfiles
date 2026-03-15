# Caelestia Quickshell Configuration

## Project Overview
Caelestia is a highly customized desktop shell configuration powered by [Quickshell](https://outfoxxed.github.io/quickshell/). It provides a modern, Material You-inspired (M3) desktop environment tailored for Linux users, specifically integrating with Hyprland and various system services.

The shell features:
- **Dynamic Theming:** A Material 3-based color system that extracts palettes from wallpapers and applies them across the shell and supported applications.
- **System Integration:** Deep integration with Hyprland (workspaces, window rules, keybinds), Pipewire (audio/microphone control), MPRIS (media playback), and NetworkManager.
- **Configurable UI:** Components like an interactive bar, dashboard, control center, and notification system, all manageable via a centralized JSON configuration (`shell.json`).
- **Workspace Management:** Automated application launching and workspace toggling (e.g., specialized workspaces for communications, music, etc.).

## Architecture
- **`shell.qml`:** The root entry point that initializes the shell layers (Background, Drawers, Lock screen, etc.).
- **`config/`:** contains Singleton QML files that manage the shell's state and configuration. `Config.qml` handles serialization to `~/.config/caelestia/shell.json`.
- **`services/`:** Singletons that wrap system-level logic:
    - `Colours.qml`: Manages the Material 3 color palette and transparency layers.
    - `Wallpapers.qml`: Handles wallpaper selection and triggers color extraction via the `caelestia` CLI.
    - `Hypr.qml`: Provides an interface to Hyprland's IPC for window and workspace management.
- **`modules/`:** The visual components of the shell, organized by functional area (bar, control center, launcher, etc.).
- **`utils/`:** Helper Singletons for common tasks like icon lookup (`Icons.qml`), path resolution (`Paths.qml`), and networking.

## Building and Running
This project is a Quickshell configuration and does not require a traditional build step.

### Running the Shell
To start the Caelestia shell, ensure `quickshell` is installed and run:
```bash
quickshell -d /home/tony/.config/quickshell/caelestia/shell.qml
```
*Note: The `-d` flag enables the debug/daemon mode used in the project's autostart.*

### Dependencies
- **Quickshell:** The runtime engine.
- **caelestia-cli:** A Python-based utility script (typically located at `/usr/bin/caelestia`) used for wallpaper management and theme generation.
- **Hyprland:** The target Wayland compositor.
- **Optional Tools:** `matugen`, `wal`, `papirus-folders`, `dconf` (for various theming integrations).

## Development Conventions
- **Singleton Pattern:** Heavily used for configuration and system services to ensure a single source of truth across all QML files.
- **Material 3 Integration:** UI elements should refer to `Colours.palette` or `Colours.tPalette` (for transparent layers) to maintain thematic consistency.
- **JSON Persistence:** All persistent user settings are stored in `Config.qml` and serialized to `shell.json`. When adding new properties, ensure they are added to the corresponding `serialize` functions in `Config.qml`.
- **Naming Conventions:** 
    - Service singletons are generally capitalized (e.g., `Hypr`, `Audio`, `Colours`).
    - Internal component properties use camelCase.
- **Component Reusability:** Common UI patterns (rectangles, text, buttons) should extend base components in `components/` to inherit standard animations and styling.
