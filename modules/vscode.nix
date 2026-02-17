{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    extensions = with pkgs.vscode-extensions; [
      # 語言支援
      ms-python.python
      ms-python.vscode-pylance
      rust-lang.rust-analyzer
      golang.go
      ms-vscode.cpptools

      # Nix 支援
      jnoortheen.nix-ide

      # Web 開發
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      bradlc.vscode-tailwindcss

      # Git 工具
      eamodio.gitlens
      mhutchie.git-graph

      # 編輯器強化
      vscodevim.vim
      usernamehw.errorlens
      christian-kohler.path-intellisense
      streetsidesoftware.code-spell-checker

      # 主題與外觀
      pkief.material-icon-theme
      zhuangtongfa.material-theme

      # 其他工具
      ms-vscode-remote.remote-ssh
      ms-azuretools.vscode-docker
      redhat.vscode-yaml
      tamasfe.even-better-toml
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # 從 Marketplace 安裝（補充 nixpkgs 中沒有的套件）
      {
        name = "catppuccin-vsc";
        publisher = "Catppuccin";
        version = "3.15.0";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      }
    ];

    userSettings = {
      # 編輯器外觀
      "workbench.colorTheme" = "One Dark Pro";
      "workbench.iconTheme" = "material-icon-theme";
      "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', monospace";
      "editor.fontSize" = 14;
      "editor.fontLigatures" = true;
      "editor.lineHeight" = 1.6;
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "workbench.startupEditor" = "none";

      # 編輯器行為
      "editor.tabSize" = 2;
      "editor.insertSpaces" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = false;
      "editor.trimAutoWhitespace" = true;
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;
      "editor.rulers" = [ 80 120 ];
      "editor.wordWrap" = "off";
      "editor.minimap.enabled" = false;
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = true;
      "editor.inlineSuggest.enabled" = true;

      # 終端機
      "terminal.integrated.fontFamily" = "'JetBrains Mono', monospace";
      "terminal.integrated.fontSize" = 13;
      "terminal.integrated.defaultProfile.linux" = "zsh";

      # 檔案管理
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "files.autoSave" = "onFocusChange";
      "files.exclude" = {
        "**/.git" = true;
        "**/.DS_Store" = true;
        "**/node_modules" = true;
        "**/__pycache__" = true;
        "**/.pytest_cache" = true;
        "**/*.pyc" = true;
      };

      # Git 設定
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "gitlens.hovers.currentLine.over" = "line";

      # 語言特定設定
      "[nix]" = {
        "editor.tabSize" = 2;
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
      "[python]" = {
        "editor.tabSize" = 4;
        "editor.defaultFormatter" = "ms-python.python";
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };

      # Nix IDE 設定
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";

      # Python 設定
      "python.languageServer" = "Pylance";
      "python.analysis.typeCheckingMode" = "basic";

      # Prettier 設定
      "prettier.singleQuote" = true;
      "prettier.semi" = true;
      "prettier.trailingComma" = "es5";
      "prettier.printWidth" = 80;

      # 效能優化
      "extensions.autoCheckUpdates" = false;
      "telemetry.telemetryLevel" = "off";
      "update.mode" = "none";
    };

    keybindings = [
      {
        key = "ctrl+shift+t";
        command = "workbench.action.terminal.new";
      }
      {
        key = "ctrl+shift+f";
        command = "editor.action.formatDocument";
        when = "editorHasFocus";
      }
      {
        key = "alt+shift+up";
        command = "editor.action.copyLinesUpAction";
        when = "editorTextFocus";
      }
      {
        key = "alt+shift+down";
        command = "editor.action.copyLinesDownAction";
        when = "editorTextFocus";
      }
    ];
  };
}
