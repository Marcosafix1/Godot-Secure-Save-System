# 🛡️ Secure Global Save System for Godot 4.x

A robust, encrypted, and easy-to-use save system for Godot Engine. This plugin provides a **Global (AutoLoad)** singleton that handles data persistence, encryption, and automatic backups.

## ✨ Features
- **Global Access:** Use `Save.Save_game()` from any script without setup.
- **Hardware-Locked Encryption:** Saves are encrypted using the device's unique ID, preventing save-file sharing/tampering.
- **Data Integrity:** Uses SHA256 hashing to verify that data hasn't been corrupted.
- **Auto-Backup:** Automatically maintains a backup file and recovers data if the main save is lost.
- **Type Safety:** Supports all Godot Variant types (int, float, Vector2, Dictionary, etc.) using `var_to_str`.

## 🚀 Installation
1. Download the `addons/secure_save` folder.
2. Place it into your project's `addons/` directory.
3. Go to **Project Settings > Plugins** and enable **"Secure Global Save"**.
4. The plugin will automatically register a Global Singleton named `Save`.

## 🛠️ How to Use

### Saving Data
```gdscript
# Save player progress
Save.Save_game("Player", "level", 15)
Save.Save_game("Settings", "volume", 0.8)
