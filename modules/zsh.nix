{ config, pkgs, ... }:

{
  # Starship 提示符
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      # 可選：顯示更多資訊
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        symbol = " ";
      };

      nix_shell = {
        symbol = " ";
      };
    };
  };

  # Zsh 配置
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # 可選：Shell 別名
    shellAliases = {
      ll = "ls -alh";
      la = "ls -A";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      hm-switch = "home-manager switch --flake /etc/nixos#eric";
      
      # Git 別名
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
    };

    # 使用新的 initContent 替代 initExtra
    initContent = ''
      # 自定義環境變數
      export EDITOR="nvim"
      
      # 快速導航
      cdnix() {
        cd /etc/nixos
      }
    '';

    # 可選：歷史記錄設定
    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
    };
  };
}
