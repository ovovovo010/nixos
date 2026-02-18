{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    code-cursor

    # Language servers & tools
    zls                          # Zig
    pyright                      # Python
    ruff                         # Python linter/formatter
    jdt-language-server          # Java (你說有裝 Java 可直接用)
    nil                          # Nix
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted  # HTML/CSS/JSON
    rust-analyzer                # Rust
    gopls                        # Go
    clang-tools                  # C/C++
    lua-language-server          # Lua
    bash-language-server         # Bash
  ];

  # 用 programs.vscode 管理設定（Cursor 完全相容 VSCode 格式）
  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor;

    extensions = with pkgs.vscode-extensions; [
      # ── 繁體中文 ────────────────────────────────────────────────────
      ms-ceintl.vscode-language-pack-zh-hant

      # ── Git ─────────────────────────────────────────────────────────
      eamodio.gitlens
      mhutchie.git-graph

      # ── 外觀 ────────────────────────────────────────────────────────
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      pkief.material-icon-theme

      # ── 通用工具 ────────────────────────────────────────────────────
      editorconfig.editorconfig
      esbenp.prettier-vscode
      streetsidesoftware.code-spell-checker
      usernamehw.errorlens
      christian-kohler.path-intellisense

      # ── Python ──────────────────────────────────────────────────────
      ms-python.python
      ms-python.vscode-pylance
      ms-python.debugpy

      # ── Java ────────────────────────────────────────────────────────
      redhat.java
      vscjava.vscode-java-debug
      vscjava.vscode-java-test
      vscjava.vscode-maven

      # ── Nix ─────────────────────────────────────────────────────────
      jnoortheen.nix-ide
      mkhl.direnv

      # ── Web ─────────────────────────────────────────────────────────
      dbaeumer.vscode-eslint
      bradlc.vscode-tailwindcss

      # ── Markdown ────────────────────────────────────────────────────
      yzhang.markdown-all-in-one
    ];

    userSettings = {
      # ── 語言 ──────────────────────────────────────────────────────
      "locale" = "zh-hant";

      # ── 外觀 ──────────────────────────────────────────────────────
      "workbench.colorTheme" = "Catppuccin Macchiato";
      "workbench.iconTheme" = "catppuccin-macchiato";
      "editor.fontFamily" = "'JetBrains Mono', 'Noto Sans CJK TC', monospace";
      "editor.fontSize" = 14;
      "editor.lineHeight" = 1.6;
      "editor.fontLigatures" = true;
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.smoothScrolling" = true;
      "workbench.list.smoothScrolling" = true;
      "editor.renderWhitespace" = "boundary";
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = true;
      "editor.minimap.enabled" = false;

      # ── 編輯器行為 ────────────────────────────────────────────────
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "editor.tabSize" = 2;
      "editor.insertSpaces" = true;
      "editor.wordWrap" = "on";
      "files.autoSave" = "onFocusChange";
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;

      # ── Terminal ──────────────────────────────────────────────────
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.fontFamily" = "'JetBrains Mono'";
      "terminal.integrated.fontSize" = 13;

      # ── Git ───────────────────────────────────────────────────────
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "gitlens.codeLens.enabled" = false;

      # ── Python ───────────────────────────────────────────────────
      "python.languageServer" = "Pylance";
      "[python]"."editor.defaultFormatter" = "ms-python.black-formatter";
      "python.formatting.provider" = "none";

      # ── Java ─────────────────────────────────────────────────────
      "java.configuration.runtimes" = [
        {
          "name" = "JavaSE-21";
          "path" = "${pkgs.jdk21}";
          "default" = true;
        }
      ];
      "java.jdt.ls.java.home" = "${pkgs.jdk21}";

      # ── Nix ──────────────────────────────────────────────────────
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";

      # ── Zig ──────────────────────────────────────────────────────
      "zig.zls.path" = "${pkgs.zls}/bin/zls";

      # ── ErrorLens ────────────────────────────────────────────────
      "errorLens.enabledDiagnosticLevels" = [ "error" "warning" ];

      # ── 其他 ──────────────────────────────────────────────────────
      "telemetry.telemetryLevel" = "off";
      "update.mode" = "none";
      "window.titleBarStyle" = "custom";
    };

    keybindings = [
      # 格式化
      { key = "shift+alt+f"; command = "editor.action.formatDocument"; }
      # 終端機
      { key = "ctrl+grave"; command = "workbench.action.terminal.toggleTerminal"; }
      # 分割編輯器
      { key = "ctrl+\\"; command = "workbench.action.splitEditor"; }
      # 關閉標籤
      { key = "ctrl+w"; command = "workbench.action.closeActiveEditor"; }
      # 側邊欄
      { key = "ctrl+b"; command = "workbench.action.toggleSidebarVisibility"; }
      # 快速開啟
      { key = "ctrl+p"; command = "workbench.action.quickOpen"; }
      # 指令面板
      { key = "ctrl+shift+p"; command = "workbench.action.showCommands"; }
      # 移動行
      { key = "alt+up"; command = "editor.action.moveLinesUpAction"; }
      { key = "alt+down"; command = "editor.action.moveLinesDownAction"; }
      # 複製行
      { key = "shift+alt+up"; command = "editor.action.copyLinesUpAction"; }
      { key = "shift+alt+down"; command = "editor.action.copyLinesDownAction"; }
    ];
  };
}
