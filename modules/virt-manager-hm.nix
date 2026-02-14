{ pkgs, ... }:

{

  # 安裝輔助工具
  home.packages = with pkgs; [
    spice-gtk    # 支援剪貼簿同步與音訊轉發
    virt-viewer  # 輕量化視窗查看器
  ];

  # 使用 dconf 自動配置連線，避免手動點選
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
