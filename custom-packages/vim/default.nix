{ pkgs }:

let
  configurable_nix_path = <nixpkgs/pkgs/applications/editors/vim/configurable.nix>;
  my_vim_configurable = with pkgs; vimUtils.makeCustomizable (callPackage configurable_nix_path {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Foundation CoreData;
    inherit (darwin) libobjc cf-private;

    features = "huge";
    python = pkgs.python.withPackages (ps: [ ps.websocket_client ps.sexpdata ]);
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

      colorscheme gardener

      let g:ctrlp_z_nerdtree = 1
      let g:ctrlp_extensions = ['Z', 'F']

      nnoremap sz :CtrlPZ<Cr>
      nnoremap sf :CtrlPF<Cr>

      set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.jar,*/target/*
      set clipboard=unnamedplus
 
      let ensime_server_v2=1
      autocmd BufWritePost *.scala silent :EnTypeCheck
      au FileType scala nnoremap <localleader>t :EnType<CR>
      au FileType scala nnoremap <localleader>df :EnDeclaration<CR>
    '';

    vimrcConfig.vam.pluginDictionaries = [
      # load always
      { names = [ 
        "youcompleteme"
        "nerdtree"
        "vim-airline"
        "ctrlp-vim"
        "ctrlp-z"
        "vim-colorschemes"
        "ale"
        "ghcmod"
        "vimproc"
        "ensime-vim"
      ];}
    ];
  }
