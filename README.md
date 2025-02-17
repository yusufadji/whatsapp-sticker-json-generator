# WhatsApp Sticker Content JSON Generator

![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux-green.svg)
![Version](https://img.shields.io/badge/version-1.0-blue.svg?cacheSeconds=2592000)
![Stargazers](https://img.shields.io/github/stars/yusufadji/whatsapp-sticker-json-generator)
![Forks](https://img.shields.io/github/forks/yusufadji/whatsapp-sticker-json-generator)

Easily automate the creation and updating of `contents.json` for WhatsApp stickers! This tool scans the `assets` directory of your WhatsApp sticker project and generates the necessary JSON file, saving you time and effort.

## 🚀 Features

- [x] **Auto-Generate `contents.json`** – No manual edits required!
- [x] **Cross-Platform Support** – Works on both **Windows** and **Linux**.
- [x] **Simple & Efficient** – Just update a few variables and run the script.
- [x] **Folder-Based Organization** – Automatically detects sticker packs inside `assets`.

## 📌 Supported Platforms

- **Windows** – `generate-content-json.bat`
- **Linux** – `generate-content-json.sh` *(tested and verified)*

> **Note:** The Windows script is not tested yet.

---

## 🔧 Getting Started

### Prerequisites

#### Windows
Ensure `jq` is installed:
- **Using Chocolatey**:
  ```bash
  choco install jq
  ```
- **Using Scoop**:
  ```bash
  scoop install jq
  ```
- **Manual Installation**: Download from the [official jq website](https://stedolan.github.io/jq/download/) and add it to your system's `PATH`.

#### Linux
Install `jq` via package manager:
```bash
sudo apt-get install jq  # Debian/Ubuntu
sudo yum install jq      # CentOS/RHEL
sudo dnf install jq      # Fedora
```
Ensure execution permissions for the script:
```bash
chmod +x generate-content-json.sh
```

### 📥 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yusufadji/whatsapp-sticker-json-generator.git
   cd whatsapp-sticker-json-generator
   ```
2. Place your sticker files in the `assets` folder.

### ▶️ Usage

#### Linux
1. Open `generate-content-json.sh` in a text editor and modify the `[MODIFY THIS]` variables.
2. Run:
   ```bash
   ./generate-content-json.sh
   ```

#### Windows
1. Open `generate-content-json.bat` and modify the `REM [MODIFY THIS]` variables.
2. Double-click `generate-content-json.bat` to execute.

---

## 📂 Example Folder Structure

Organize your project like this:
```bash
project-root/
│
├── assets/
│   ├── sticker_pack_1/
│   │   ├── sticker1.png
│   │   ├── sticker2.png
│   │   └── tray.png
│   ├── sticker_pack_2/
│   │   ├── sticker1.png
│   │   └── tray.png
├── generate-content-json.bat
└── generate-content-json.sh
```

## 📌 Development Status
- ✅ **Linux script is fully functional**
- 🚧 **Windows script is not tested yet**
- 🚀 **Future updates planned!**

## 🤝 Contributing

Want to improve this tool? Feel free to submit pull requests or report issues!

## 📜 License

This project is licensed under the **MIT License** – see the [LICENSE](https://github.com/yusufadji/whatsapp-stickers-json-generator/blob/main/LICENSE) file for details.

---

💡 **Make your WhatsApp sticker management effortless!** Give this project a ⭐ on GitHub!

