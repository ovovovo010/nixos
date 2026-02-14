{ config, pkgs, ... }:

{
  # 字體包
  home.packages = with pkgs; [
    # 基礎字體
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    
    # Nerd Fonts（含圖標）
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    
     nerd-fonts.hack
     nerd-fonts.meslo-lg
     nerd-fonts.iosevka
     nerd-fonts.ubuntu-mono
     font-awesome        # 圖標字體
     material-icons      # Material Design 圖標
  ];

  # 字體配置
  fonts.fontconfig.enable = true;
}
