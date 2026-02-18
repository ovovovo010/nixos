
{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./System/virt-manager-System.nix
      ./System/fcitx5-System.nix
      ./System/greetd-System.nix
      ./System/nvidia-driver-System.nix
      ./System/Packages-System.nix
      ./System/users-System.nix
      ./System/steam-System.nix
      ./System/data.nix
      ./System/clamav.nix
      ./System/btrfs.nix
      ./System/generation.nix
      ./System/systemd.nix

    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_6_12;

   networking.hostName = "nixos"; 

  networking.networkmanager.enable = true;

   time.timeZone = "Asia/Taipei";

   i18n.defaultLocale = "en_US.UTF-8";


   services.xserver.enable = true;

   services.flatpak.enable = true;


   nix.settings.substituters = [
  "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # 清華鏡像
  "https://cache.nixos.org/"  # 官方源作為備用
];
  
  virtualisation.docker = {
    enable = true;
};
  hardware.nvidia-container-toolkit.enable = true;
  

   services.pipewire = {
     enable = true;
     pulse.enable = true;
   };




   programs.hyprland.enable = true;

   programs.niri.enable = true;




 

   nixpkgs.config.allowUnfree = true;

  

 

  system.stateVersion = "25.11"; 

}

