{ pkgs, ... }: {
  # 1. 啟用 Thunderbird 並定義 profile
  programs.thunderbird = {
    enable = true;
    profiles.eric = {  # 注意：錯誤訊息顯示您的 profile 名稱為 eric
      isDefault = true;
    };
  };

  # 2. 定義郵件帳號
  accounts.email.accounts."Proton" = {
    primary = true;  # <--- 必須加上這一行，解決 "found 0" 的問題
    address = "ovovovo010@proton.me";
    realName = "Eric";
    userName = "ovovovo010@proton.me";

  accounts.email.accounts."Gmail" = {
    primary = true;  # <--- 必須加上這一行，解決 "found 0" 的問題
    address = "ovovovo010@gmail.com";
    realName = "Eric";
    userName = "ovovovo010@gmail.com";
    
    # 關聯 Thunderbird
    thunderbird.enable = true;
    thunderbird.profiles = [ "eric" ]; # 確保帳號綁定到 eric 這個 profile
    
    # 串接 Hydroxide 本地服務
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
