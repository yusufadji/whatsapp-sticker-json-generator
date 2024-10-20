# WhatsApp Sticker Content JSON Generator

This project provides a simple solution to automatically create and update the `contents.json` file for WhatsApp stickers by scanning folders and files located in the `assets` directory of a WhatsApp sticker project.

Currently, the program consists of two scripts:

- `generate-content-json.bat`: Supports Windows.
- `generate-content-json.sh`: Supports Linux.

> **Note:** The script that has been tested so far is `generate-content-json.sh` for Linux. The Windows script is still under development.

## Features

- Automatically generates `contents.json` based on sticker files in the `assets` folder.
- Easy to use, just update a few variables and run the script.
- Supports both Windows and Linux platforms.

## Getting Started

## Prerequisites

- Ensure you have the required environment:

  - **Windows**:

    - Ensure that the `jq` library is installed. You can install it using one of the following methods:
      - Using Chocolatey:
        ```bash
        choco install jq
        ```
      - Using Scoop:
        ```bash
        scoop install jq
        ```
      - Or download the executable from the [official jq website](https://stedolan.github.io/jq/download/) and add it to your system's `PATH`.

  - **Linux**:
    - Ensure that the `jq` library is installed. You can install it using your package manager:
      ```bash
      sudo apt-get install jq  # For Debian/Ubuntu
      sudo yum install jq      # For CentOS/RHEL
      sudo dnf install jq      # For Fedora
      ```
    - Make sure you have execution permissions for the `.sh` script. You can set permissions with the following command:
      ```bash
      chmod +x generate-content-json.sh
      ```

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yusufadji/whatsapp-stickers-json-generator.git
   cd whatsapp-stickers-json-generator
   ```
2. Place your sticker files in the assets folder. Ensure each folder inside assets represents a different sticker pack.

### Usage

#### Linux

1. Open generate-content-json.sh and modify the variables under the comment # [MODIFY THIS] according to your needs.
2. Run the script:

```
./generate-content-json.sh
```

#### Windows

1. Open generate-content-json.bat and modify the variables under the comment REM [MODIFY THIS] according to your needs.
2. Double-click on generate-content-json.bat after making the changes.

### Example Folder Structure

You can put the script anywhere you want as long as you have changed the path variable in the script. I recommend putting the script in a project to make it easier to organize.

```
project-root/
│
├── assets/
│   ├── sticker_pack_1/
│   │   ├── sticker1.png
│   │   ├── sticker2.png
│   │   └── tray.png
│   └── sticker_pack_2/
│       ├── sticker1.png
│       └── tray.png
├── generate-content-json.bat
└── generate-content-json.sh
```

### Development Status

This project is currently in the development phase, and more features or updates may be added in the future. The Linux version (generate-content-json.sh) has been tested, while the Windows version (generate-content-json.bat) is still in progress.

### Contributing

Feel free to contribute by creating pull requests or reporting issues.

### License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/yusufadji/wa-stickers-json-generator/blob/main/LICENSE) file for details.
