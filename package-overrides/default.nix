let pkgsPinned = import ../nixpkgs {};
in
  pkgs : 
  {
    weechat = pkgs.callPackage ../custom-packages/weechat { };
    customVim = pkgs.callPackage ../custom-packages/vim { };
    alacritty = pkgsPinned.alacritty;
    firefox = pkgsPinned.firefox;
  }
