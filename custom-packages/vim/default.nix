{ pkgs }:

let
  configurable_nix_path = <nixpkgs/pkgs/applications/editors/vim/configurable.nix>;
  my_vim_configurable = with pkgs; vimUtils.makeCustomizable (callPackage configurable_nix_path {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Foundation CoreData;
    inherit (darwin) libobjc cf-private;

    features = "huge";
    python = pkgs.python3.withPackages (ps: [ ps.websocket_client ps.sexpdata ]);
    lua = pkgs.lua5_1;
    gui = config.vim.gui or "auto";

    flags = [ "python" "X11" ];
  });

in
  my_vim_configurable.customize {
    name = "vim";
    vimrcConfig.customRC = ''
      let
      syntax on
      filetype on
      filetype plugin on
      filetype plugin indent on
      set backspace=indent,eol,start

      let g:deoplete#enable_at_startup = 1

      " when pressing tab use 2 spaces width
      set expandtab
      " show existing tab with 2 spaces width
      set tabstop=2
      set softtabstop=2
      " when indenting with '>', use 2 spaces width
      set shiftwidth=2

      let mapleader = " "

      nmap <Leader>pt :NERDTreeToggle<CR>

      map <C-J> <C-W>j
      map <C-K> <C-W>k
      map <C-H> <C-W>h
      map <C-L> <C-W>l

      colorscheme molokai

      " nnoremap <C-p> :<C-u>Denite file_rec<CR>
      nnoremap <C-s> :<C-u>Denite grep<CR>

      set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.jar,*/target/*
      set clipboard=unnamedplus

      autocmd BufWritePre * :%s/\s\+$//e

      " let ensime_server_v2=1
      " autocmd BufWritePost *.scala silent :EnTypeCheck
      " au FileType scala nnoremap <localleader>t :EnType<CR>
      " au FileType scala nnoremap <localleader>df :EnDeclaration<CR>
    '';

    vimrcConfig.vam.pluginDictionaries = [
      # load always
      { names = [
        "youcompleteme"
        "nerdtree"
        "vim-airline"
        "vim-colorschemes"
        "ale"
        "ghcmod"
        "neco-ghc"
        "vimproc"
        "denite"
        "ctrlp-vim"
      ];}
    ];
  }

