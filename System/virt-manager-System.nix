{ config, pkgs, ... }:

{
  # 啟用系統級 Virt-manager 程式
  programs.virt-manager.enable = true;

  services.spice-vdagentd.enable = true;

virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    # 移除 ovmf.enable = true;
  };
};
  # 允許使用者使用 libvirtd (eric 需符合您的使用者名稱)
  users.users.eric.extraGroups = [ "libvirtd" "kvm" "video" "render" ];

 } 
