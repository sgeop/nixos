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

  fonts.enableFontDir = true;

  fonts.fonts = with pkgs; [ dejavu_fonts hack-font font-awesome-ttf ];

  # List packages installed in system profile. To search by name, run: $ nix-env
  # -qaP | grep wget
  environment.systemPackages = with pkgs; [
    bashInteractive
    iana-etc
    customVim
    customEmacs
    stow
    yi
    sops
    pass
    gnupg
    dejavu_fonts
    lxappearance
    firefox
    font-awesome-ttf
    git
    hack-font
    kubectl
    nitrogen
    python3
    openjdk
    slack
    termite
    termite.terminfo
    weechat
    wget
    xcape
    xscreensaver
    xorg.xbacklight
    maven
    gradle
    sbt
    dmenu
    taffybar
    (polybar.override { i3Support = true; })
  ];


  nixpkgs.config.packageOverrides = (import ./package-overrides);


  # List services that you want to enable:

  # services.emacs.enable = true;
  # services.emacs.package = pkgs.customEmacs;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ]; Or disable the firewall
  # altogether. networking.firewall.enable = false;

  # Enable CUPS to print documents. services.printing.enable = true;

  # Enable Postgres server
  # services.postgresql.enable = true;
  # services.postgresql.package = pkgs.postgresql_10;

  # Enable local Kubernetes cluster
  # services.kubernetes.roles = ["master" "node"];
  # services.kubernetes.addons.dashboard.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:ctrl_modifier";

  services.compton = {
    enable = true;
    opacityRules = [
      "86:class_g = 'Termite'"
    ];
  };

  services.xserver.synaptics = {
    enable = true;
    maxSpeed = "1.2";
    twoFingerScroll = true;
    tapButtons = false;
  };

  # services.xserver.windowManager = {
  #   default = "i3";
  #   i3.enable = true;
  #   i3.package = pkgs.i3-gaps;

  #   i3.configFile = import ./config/i3.nix {
  #     inherit config;
  #     inherit pkgs;
  #   };

  #   i3.extraPackages = with pkgs; [
  #     dmenu
  #     i3blocks-gaps
  #     i3lock-fancy
  #   ];
  # };

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [
      haskellPackages.xmonad-contrib
      haskellPackages.xmonad-extras
      haskellPackages.xmonad
      haskellPackages.xmobar
      haskellPackages.taffybar
      haskellPackages.status-notifier-item
    ];
  };

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.sessionCommands = ''
    xrandr --output eDP1 --scale 0.8x0.8
    xrandr --output DP2 --auto --above eDP1

    ${pkgs.feh}/bin/feh --bg-fill $HOME/Images/fractal.png

    xscreensaver -no-splash &
  '';

  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.xautolock = {
    enable = true;
    locker = "${pkgs.xscreensaver}/bin/xscreensaver-command -l";
  };


  programs.bash.enableCompletion = true;

  users.defaultUserShell = "${pkgs.bashInteractive}/bin/bash";


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

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    # builtins.readFile("/home/spietz/.ssh/id_rsa.pub")
  ];

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
