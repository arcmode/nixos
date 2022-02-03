# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:


{
  nix = {
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "dddb25a7653389d754d3f988e603ec0ec38223db";
    }))
  ];

  services.emacs.enable = true;
  services.emacs.package = pkgs.emacsPgtkGcc;

  disabledModules = [ "services/x11/window-managers/exwm.nix" ];
  imports =
    [
      ./modules/exwm/exwm.nix
    ];

  time.timeZone = "America/Los_Angeles";
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.windowManager.exwm = {
   #   enable = true;
    #  package = pkgs.emacsPgtkGcc;
      # enableDefaultConfig = false;
  #};

  services.openssh = {
    enable = true;
  };

  security.sudo.wheelNeedsPassword = false;
  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
    users.david = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "networkmanager" ];
      initialPassword = "password";
    };
  };

  nix = {
    settings.allowed-users = [ "root" "david" ];
    settings.trusted-users = [ "root" "david" ];
    distributedBuilds = true;
    settings.auto-optimise-store = true;
    checkConfig = true;
    gc.automatic = true;
    gc.dates = "weekly";
    optimise.automatic = true;
    settings.sandbox = false;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    vim
    emacsPgtkGcc
    google-chrome
    alacritty
    neofetch
    cowsay
    fortune
    lolcat
    nixpkgs-fmt
    nodePackages.pyright
    nodejs
  ];
  system.stateVersion = "21.11"; # Did you read the comment?
}

