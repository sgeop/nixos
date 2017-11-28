pkgs : {
  weechat = pkgs.callPackage ../custom-packages/weechat { };
  customVim = pkgs.callPackage ../custom-packages/vim { };
}
