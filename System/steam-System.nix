{ pkgs, ... }:

{
  # 1. 啟用 Steam 硬體支援與遊戲模式
  programs.steam = {
    enable = true;
    # 開放防火牆連接埠（用於 Steam 本地傳輸與手機串流）
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    # 優化遊戲效能的工具
    gamescopeSession.enable = true;
    extest.enable = true;
     extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  services.thermald.enable = true;


# enableRenice 必須定義在 gamemode 下
  programs.gamemode = {
    enable = true;
    enableRenice = true; 
};

  systemd.tmpfiles.rules = [
  "L+ /run/host/run/opengl-driver - - - - /run/opengl-driver"
  "L+ /run/host/run/opengl-driver-32 - - - - /run/opengl-driver-32"
];

  hardware.graphics = {
  enable = true;
  enable32Bit = true;  # 這個取代了 driSupport32Bit
};

 
  services.devmon.enable = true; 
  services.gvfs.enable = true;

  users.users.eric.extraGroups = [ "gamemode" ];


 
}
