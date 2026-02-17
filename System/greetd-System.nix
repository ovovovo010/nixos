{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --sessions /etc/greetd/sessions";
        user = "eric";
      };
    };
  };

  # 手動建立 session 文件
  environment.etc."greetd/sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Exec=Hyprland
    Type=Application
  '';

     environment.etc."greetd/sessions/niri.desktop".text = ''
    [Desktop Entry]
    Name=Niri
    Exec=niri
    Type=Application
  '';

 

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
