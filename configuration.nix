# Edit this configuration file to define what should be installed on your system.  
# Help is available in the configuration.nix(5) man page and in the NixOS manual 
# (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda4";
      preLVM = true;
    }
  ];

  boot.cleanTmpDir = true;

  nixpkgs.config.allowUnfree = true;
  networking.networkmanager.enable = true;

  # networking.hostName = "nixos"; # Define your hostname. 
  # networking.wireless.enable = true; # Enables wireless support via 
  # wpa_supplicant.

  # Select internationalisation properties. i18n = {
  #   consoleFont = "Lat2-Terminus16"; consoleKeyMap = "us"; defaultLocale = 
  #   "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search by name, run: $ nix-env 
  # -qaP | grep wget
  environment.systemPackages = with pkgs; [
    bashInteractive
    wget
    chromium
    firefox
    slack
    xcape
    customVim
    neovim
    emacs
    tmux
    git
    python
    racket
    weechat
  ];

  nixpkgs.config.packageOverrides = (import ./package-overrides);

  # List services that you want to enable:

  # Enable the OpenSSH daemon. services.openssh.enable = true;

  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ]; 
  # networking.firewall.allowedUDPPorts = [ ... ]; Or disable the firewall 
  # altogether. networking.firewall.enable = false;

  # Enable CUPS to print documents. services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.desktopManager.default = "gnome3";

  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.default = "xmonad";
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.spietz = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "messagebus"
      "systemd-journal"
      "disk"
      "audio"
      "video"
    ];
  };

  systemd.user.services."xcape" = {
    enable = true;
    description = "xcape to use caps lock as esc";
    wantedBy = [ "default.target" ];
    path = [ pkgs.rxvt_unicode ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.xcape}/bin/xcape -e 'Caps_Lock=Escape'";
  };

  virtualisation.docker.enable = true;

  # powerManagement.enable = true; services.tlp.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
