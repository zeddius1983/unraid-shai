# Shai (Shell AI) - Unraid Plugin

Shai is a lightweight, powerful Unraid plugin that brings AI-assisted command advice and smart shell autocomplete directly to your Unraid NAS terminal. It acts as an interactive assistant for your Bash sessions and explicitly preserves your command history.

## What it does

1.  **Persistent Bash History:** Unraid runs entirely in RAM, meaning your `~/.bash_history` is destroyed on every reboot. Shai connects your `HISTFILE` to a persistent file stored on your flash drive (`/boot/config/plugins/shai/.bash_history`), immediately keeping your command history safe. It also syncs commands across multiple concurrent SSH sessions.
2.  **Smart Shell Autocomplete:** Pressing `Ctrl+N` while typing a command will trigger the `shai` script to read your current command buffer, send it alongside your recent history to the configured AI API (OpenAI or Ollama), and instantly auto-fill the rest of the command!
3.  **CLI Advisor Mode:** Run the `shai "your question"` command to ask the AI questions directly. It reads your recent command history to provide context-aware answers.
4.  **WebUI Integration:** Easily configure your desired AI API endpoint and Model via Unraid's Settings page context.

## Requirements

-   Unraid OS (v6.9.0+)
-   An OpenAI API key **OR** a locally running Ollama instance with API access (e.g. `http://<your-server>:11434/api/generate`).

## How to Build

If you are developing or modifying the plugin locally, you can use the included `build.sh` script to create the installable plugin package:

1.  Modify any code in the `source/shai` directory or the `shai.plg` file.
2.  Run the build script:
    ```bash
    ./build.sh
    ```
    This script will assemble the contents of `source/shai` into a compressed `shai.txz` archive.

## How to Install

### Method 1: Remote GitHub URL (Recommended for Distribution)
If you are hosting this plugin on GitHub:
1.  Push your code to a public GitHub repository. Ensure `shai.plg` is in the root and compiled `shai.txz` is placed in an `archive/` folder in your repo if following the default `.plg` structure.
2.  Go to the **Plugins** tab in the Unraid WebUI.
3.  Click on the **Install Plugin** sub-tab.
4.  Enter the raw GitHub URL to your `shai.plg` file (e.g., `https://raw.githubusercontent.com/username/repo/main/shai.plg`) and click **Install**. Unraid will download the `.plg` and package automatically.

### Method 2: Local Command Line
1.  Copy the compiled `shai.txz` file and the `shai.plg` descriptor to your Unraid flash drive inside the plugin directory: `/boot/config/plugins/shai/`. (You might need to create this directory via a network share, such as `\\tower\flash\config\plugins\shai`).
2.  SSH into your Unraid server.
3.  Install the plugin using the appropriate command for your Unraid version:

    *   **For Unraid 6.x:**
        ```bash
        installplg /boot/config/plugins/shai/shai.plg
        ```
    *   **For Unraid 7.x:**
        ```bash
        plugin install /boot/config/plugins/shai/shai.plg
        ```

### Method 3: Local Unraid WebUI
1. If you copied `shai.plg` and `shai.txz` to your server (e.g., to `/boot/config/plugins/shai/shai.plg`), you can install it from the interface.
2. Go to the **Plugins** tab in the Unraid WebUI.
3. Click on the **Install Plugin** sub-tab.
4. Enter the local path to the `.plg` file (e.g., `/boot/config/plugins/shai/shai.plg`) in the input field and click **Install**.

## Setup & Configuration

1.  Open the Unraid WebUI in your browser.
2.  Navigate to **Settings** -> **AI History**.
3.  Enter your **AI API URL**, **API Key**, and **Model** name.
    *   *Ollama Example:* URL: `http://YOUR_SERVER_IP:11434/api/generate`, Model: `llama3`, (Key left blank).
    *   *OpenAI Example:* URL: `https://api.openai.com/v1/chat/completions`, Key: `sk-yourkey...`, Model: `gpt-4o-mini`.
4.  Click **Apply** to save your configurations.

## Usage

**Autocomplete Command:**
Type the beginning of a command, such as `docker pull`, and press **`Ctrl+N`** on your keyboard to instantly have the AI complete your command prompt based on your prior history and activity.

**Direct Advice:**
To query the AI about specific tasks without modifying your prompt buffer, you can execute Shai manually with a string argument:
```bash
shai "how do I view the logs for the plex container?"
```
The AI will answer contextually, understanding what you are attempting to ask.
