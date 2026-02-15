{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/zsh.nix
    ./modules/packages.nix
    ./modules/waybar.nix
    ./modules/thunar.nix
    ./modules/fonts.nix
    ./modules/hyprland.nix
    ./modules/virt-manager-hm.nix
    ./modules/steam-tools.nix
    ./modules/thunderbird.nix
    ./modules/hydroxide.nix
    ./modules/rofi.nix
    ./modules/cava.nix
    ./modules/hyprlock-idle.nix
    ./modules/swaync.nix
    ./modules/spicetify.nix

  ];

  home.username = "eric";
  home.homeDirectory = lib.mkForce "/home/eric";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
