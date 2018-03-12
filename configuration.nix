# Edit this configuration file to define what should be installed on your system.  # Help is available in the configuration.nix(5) man page and in the NixOS manual
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

  hardware.pulseaudio.enable = true;

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
    firefox
    slack
    xcape
    xscreensaver
    customVim
    emacs
    tmux
    git
    python
    weechat
    alacritty
  ];

  nixpkgs.config.packageOverrides = (import ./package-overrides);

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.extraUsers.root.openssh.authorizedKeys.keys = [
    # builtins.readFile("/home/spietz/.ssh/id_rsa.pub")
  ];

  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ]; Or disable the firewall
  # altogether. networking.firewall.enable = false;

  # Enable CUPS to print documents. services.printing.enable = true;
  
  # Enable Postgres server
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql100;


  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:ctrl_modifier";

  services.xserver.synaptics = {
    enable = true;
    maxSpeed = "1.2";
    twoFingerScroll = true;
    tapButtons = false;
  };

  services.xserver.windowManager = {
    default = "i3";
    i3.enable = true;
    i3.configFile = import ./i3-config.nix { inherit config; inherit pkgs; };
  }; 

  services.xserver.displayManager.slim = {
    enable = true;
    defaultUser = "spietz";
  };

  services.xserver.displayManager.sessionCommands = ''
    xrandr --output eDP1 --scale 0.8x0.8
    xrandr --output DP2 --auto --above eDP1
    xscreensaver -no-splash &
  '';

  services.xserver.xautolock = {
    enable = true;
    locker = "xscreensaver-command -l";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.spietz = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [
      "wheel"
      "docker"
      "virtualbox"
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
    serviceConfig.ExecStart = "${pkgs.xcape}/bin/xcape -e 'Caps_Lock=Escape'"; };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # powerManagement.enable = true; services.tlp.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";


}
