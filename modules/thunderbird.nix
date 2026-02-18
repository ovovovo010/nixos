{ pkgs, ... }: {
  programs.thunderbird = {
    enable = true;
    profiles.eric = {
      isDefault = true;
    };
  };

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
      port = 1143;
      tls.enable = false;
    };
    smtp = {
      host = "127.0.0.1";
      port = 1025;
      tls.enable = false;
    };
  };

  accounts.email.accounts."Gmail" = {
    primary = false;
    address = "ovovovo010@gmail.com";
    realName = "Eric";
    userName = "ovovovo010@gmail.com";
    thunderbird.enable = true;
    thunderbird.profiles = [ "eric" ];
    imap = {
      host = "127.0.0.1";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "smtp.gmail.com";
      port = 587;
      tls.enable = true;
    };
  };
}
