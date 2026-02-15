{ inputs, pkgs, ... }: {
  # 1. 這裡直接從 inputs 引用 HM 模組，不需要動到 flake.nix 的 modules 列表
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  # 2. Spicetify 原生 HM 設定
  programs.spicetify = {
    enable = true;
    
    # 擴充商店與插件
    enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.system}.extensions; [
      marketplace  # 擴充商店
      adblock      # 擋廣告
      shuffle      # 隨機播放優化
    ];

    # 主題設定 (可選，預設是原版)
    theme = inputs.spicetify-nix.legacyPackages.${pkgs.system}.themes.catppuccin;
    colorScheme = "macchiato";
  };
}
