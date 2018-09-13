{ pkgs }:

let
  myEmacs = pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesNgGen myEmacs).emacsWithPackages;
in
  emacsWithPackages (epkgs: (with epkgs; [
    magit          # ; Integrate git <C-x g>
    zerodark-theme # ; Nicolas' theme
    undo-tree      # ; <C-x u> to show the undo tree
    nix-mode
    beacon         # ; highlight my cursor when scrolling
    nameless       # ; hide current package name everywhere in elisp code
    use-package
    evil
    evil-leader
    control-mode
    haskell-mode
    dante
    dhall-mode
    ivy
    swiper
    counsel
    neotree
    bind-key
    company
    flycheck
    ensime
  ]))

