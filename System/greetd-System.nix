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

  environment.etc."greetd/sessions/openbox.desktop".text = ''
  [Desktop Entry]
  Name=Openbox
  Exec=${pkgs.xorg.xinit}/bin/startx ${pkgs.openbox}/bin/openbox-session
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
