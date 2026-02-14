{ config, ... }:

{
  fileSystems."/mnt/data" = {
    # 這裡使用您 lsblk 查到的 UUID
    device = "/dev/disk/by-uuid/8cef1cf0-08c7-4f64-9158-911d37fcc24f";
    fsType = "ext4";
   options = [ 
    "rw" 
    "relatime" 
     # 必須明確改為 exec
    "nosuid" 
    "nodev" 
    "exec" 
  ];
  };
}
