{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    # 使用新的 settings 語法
    settings = {
      user = {
        name = "eric";
        email = "ovovovo010@proton.me";
      };
      
      safe = {
        directory = "/etc/nixos";
      };
      
      init = {
        defaultBranch = "main";
      };
      
      pull = {
        rebase = false;
      };
      
      # Git 別名（從 aliases 移到 settings.alias）
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        lg = "log --oneline --graph --all";
      };
    };
  };
}
