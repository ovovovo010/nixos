{ pkgs, ... }:

{
  # 安裝 hydroxide
  home.packages = [ pkgs.hydroxide ];

  # ─────────────────────────────────────────
  # systemd 服務：帳號 1 (ovovovo010)
  # IMAP: 127.0.0.1:1143  SMTP: 127.0.0.1:1025
  # ─────────────────────────────────────────
  systemd.user.services.hydroxide-primary = {
    Unit = {
      Description = "Hydroxide Bridge - ovovovo010@proton.me";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.hydroxide}/bin/hydroxide -imap-port 1143 -smtp-port 1025 serve";
      Restart = "on-failure";
      RestartSec = "5s";
      # 每個帳號使用獨立的設定目錄，避免衝突
      Environment = [
        "XDG_CONFIG_HOME=%h/.config/hydroxide-primary"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # ─────────────────────────────────────────
  # systemd 服務：帳號 2 (ovovovo000)
  # IMAP: 127.0.0.1:1144  SMTP: 127.0.0.1:1026
  # ─────────────────────────────────────────
  systemd.user.services.hydroxide-secondary = {
    Unit = {
      Description = "Hydroxide Bridge - ovovovo000@proton.me";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.hydroxide}/bin/hydroxide -imap-port 1144 -smtp-port 1026 serve";
      Restart = "on-failure";
      RestartSec = "5s";
      Environment = [
        "XDG_CONFIG_HOME=%h/.config/hydroxide-secondary"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # ─────────────────────────────────────────
  # 郵件帳號設定
  # ─────────────────────────────────────────
  accounts.email.accounts."Proton" = {
    primary = true;
    address = "ovovovo010@proton.me";
    realName = "Eric";
    userName = "ovovovo010@proton.me";

    thunderbird.enable = true;
    thunderbird.profiles = [ "eric" ];

    imap = {
      host = "127.0.0.1";
      port = 1143;
      tls.enable = false;
    };
    smtp = {
      host = "127.0.0.1";
      port = 1025;
      tls.enable = false;
    };
  };

  accounts.email.accounts."ProtonAlt" = {
    primary = false;
    address = "ovovovo000@proton.me";
    realName = "Eric";
    userName = "ovovovo000@proton.me";
    thunderbird.enable = true;
    thunderbird.profiles = [ "eric" ];
    imap = {
      host = "127.0.0.1";
      port = 1144;
      tls.enable = false;
    };
    smtp = {
      host = "127.0.0.1";
      port = 1026;
      tls.enable = false;
    };
  };

}
