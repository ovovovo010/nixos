{ inputs, pkgs, ... }:
{
  imports = [ inputs.spicetify-nix.nixosModules.default ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      theme = spicePkgs.themes.catppuccin; # 設定主題
      colorScheme = "macchiato";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay # 滿版顯示
        shuffle # 更好的隨機播放
        adblock # 廣告屏蔽 (依版本可能有所限制)
	marketplace
      ];
    };
}
