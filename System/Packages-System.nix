{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  openbox
  xorg.xinit
  ];
}
