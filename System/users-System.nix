{ pkgs, ... }:

{
  # 必須先建立對應的群組
  users.groups.eric = {};

  users.users.eric = {
    isNormalUser = true;  # 解決第一個錯誤
    group = "eric";      # 解決第二個錯誤
    shell = pkgs.zsh;
    extraGroups = [ 
      "wheel" 
      "libvirtd" 
      "video" 
      "render" 
      "networkmanager" 
    ];
    # 如果這裡有定義 packages，確保結尾有分號
    packages = with pkgs; [ ];
  };

  # 啟用 zsh 支援
  programs.zsh.enable = true;
}
