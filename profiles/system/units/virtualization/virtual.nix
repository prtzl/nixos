{
  pkgs,
  ...
}:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        runAsRoot = false;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = with pkgs; [
    fuse-overlayfs
    libguestfs
    spice-gtk
    spice-vdagent
    swtpm
    virt-manager
    virt-viewer
  ];

  boot = {
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "x86_64-windows"
    ];
  };
}
