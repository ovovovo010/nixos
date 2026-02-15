{ inputs, pkgs, ... }: {
  # 1. 這裡直接從 inputs 引用 HM 模組，不需要動到 flake.nix 的 modules 列表
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

programs.spicetify = {
    enable = true;
    
    # 確保這兩個變數路徑正確
    theme = inputs.spicetify-nix.legacyPackages.${pkgs.system}.themes.catppuccin;
    colorScheme = "macchiato"; 

    enabledExtensions = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in [
  #    spicePkgs.extensions.marketplace
      spicePkgs.extensions.adblock
    ];
  };
  }
