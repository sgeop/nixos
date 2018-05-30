{ mkDerivation, base, microlens-platform, mtl, stdenv, yi-core
, yi-frontend-vty, yi-fuzzy-open, yi-keymap-vim, yi-misc-modes
, yi-mode-haskell, yi-rope
}:
mkDerivation {
  pname = "yi-vim-vty-static";
  version = "0.17.1";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base microlens-platform mtl yi-core yi-frontend-vty yi-fuzzy-open
    yi-keymap-vim yi-misc-modes yi-mode-haskell yi-rope
  ];
  homepage = "https://github.com/yi-editor/yi#readme";
  license = stdenv.lib.licenses.gpl2;
}
