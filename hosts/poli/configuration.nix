{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  linux_6_16 = pkgs.linux_6_16.override {
    argsOverride = rec {
      version = "6.16.8";
      modDirVersion = "${version}";
      src = pkgs.fetchurl {
        url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "sha256-IxMRvXCE3DEplE0mu0O+b/g32oL7IQSmdwSuvKi/pp8=";
      };
    };
  };
  myKernel = pkgs.linuxPackagesFor linux_6_16;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    # inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ]
  ++ (with (lib.findModules ../../profiles/system/units); [
    steam
  ]);

  boot = {
    # kernelPackages = myKernel;
    kernelModules = [
      "nct6775" # nct6775: asrock board sensors
    ];
    supportedFilesystems = [ "ntfs" ];
  };

  hardware = {
    openrazer.enable = true;
    graphics = {
      enable = true;
      package = pkgs.pkgs-unstable.mesa;
      package32 = pkgs.pkgs-unstable.pkgsi686Linux.mesa;
    };
    graphics.extraPackages = with pkgs.pkgs-unstable; [
      intel-media-driver
      intel-vaapi-driver
      mesa
      vpl-gpu-rt
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.motherboard = "amd";
  services.openssh = {
    enable = true;
    ports = [ 8022 ];
  };

  programs = {
    obs-studio.enable = true;
    wireshark.enable = true;
  };

  environment.systemPackages = with pkgs; [
    arduino
    rsync
  ];
}
