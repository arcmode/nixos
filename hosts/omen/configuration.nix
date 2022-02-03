{ config, pkgs, lib, ... }:


let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        trustedBoot.isHPLaptop = true;
      };
    };
    tmpOnTmpfs = true;
    kernelPackages = pkgs.linuxPackages_xanmod;
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    kernelModules = [ "kvm-amd" "amdgpu" ];
    initrd.kernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
    ];
  };

  networking.hostName = "omen";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  hardware.nvidia = {
    prime = {
      offload.enable = true;
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };
  hardware.bluetooth = {
    enable = false;
    package = pkgs.bluezFull;
  };
  hardware.pulseaudio.enable = false;
  hardware.video.hidpi.enable = false;
  hardware.cpu.amd.updateMicrocode = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nvidia-offload
  ];
  environment.pathsToLink = [ "/libexec" ];
}

