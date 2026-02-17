{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  xorg.xinit
  ];
}
