{ pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs          # Wayland 螢幕擷取
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
