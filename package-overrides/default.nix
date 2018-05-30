let pkgsPinned = import ../nixpkgs {};
in
  pkgs : 
  {
    weechat = pkgs.callPackage ../custom-packages/weechat { };
    customVim = pkgs.callPackage ../custom-packages/vim { };
    alacritty = pkgsPinned.alacritty;
    firefox = pkgsPinned.firefox;
    termite = pkgs.termite.override { configFile = import ../config/termite.nix { inherit pkgs; }; };
    yi = pkgs.haskellPackages.callPackage ../custom-packages/yi {};
  }
