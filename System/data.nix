{ config, pkgs, ... }:

{
  # 挂载配置
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/d08fc080-8f82-4807-a561-c1f305f03da0";
    fsType = "ext4"; # 如果是其他格式请修改此处
    options = [ "defaults" "nofail" ];
  };

  # 自动设置权限：确保你的用户拥有该目录的读写权
  # 将 "yourusername" 替换为你的实际用户名
  systemd.tmpfiles.rules = [
    "d /mnt/data 0755 eric users -"
  ];
}
