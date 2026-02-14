{ pkgs, ... }:

{
  # 安裝必要套件
  home.packages = [ pkgs.hydroxide ];

  # 1. 自動化背景服務 (systemd user service)
  systemd.user.services.hydroxide = {
    Unit = {
      Description = "Hydroxide Proton Mail Bridge";
      After = [ "network.target" ];
    };
    Service = {
      # 確保使用正確的套件路徑執行 serve
      ExecStart = "${pkgs.hydroxide}/bin/hydroxide serve";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # 2. 郵件帳號全局設定
  accounts.email.accounts."Proton" = {
    primary = true;
    address = "ovovovo010@proton.me";
    realName = "Eric";
    userName = "ovovovo010@proton.me";
    
    # 關聯 Thunderbird
    thunderbird.enable = true;
    thunderbird.profiles = [ "eric" ]; # 這裡需對應您 programs.thunderbird.profiles 的名稱

    # 串接本地 Hydroxide 伺服器
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
}
