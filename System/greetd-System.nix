{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # 使用 tuigreet 作為介面，並預設啟動 Hyprland
	command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --sessions ${pkgs.xorg.xinit}/share/xsessions";
        user = "eric";
      };
    };
  };

  # 為了讓 tuigreet 正常顯示，優化虛擬終端機設定
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
