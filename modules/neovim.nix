{ system, config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  username = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";

  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
  lsp = (import (pkgs.fetchFromGitHub { inherit (sources.lsp-nix) owner repo rev sha256; })).outputs.packages."${builtins.currentSystem}";
in
{
  home.sessionVariables.EDITOR = "${pkgs.neovim-unwrapped}/bin/nvim";
  home.sessionVariables.VISUAL = "${pkgs.neovim-unwrapped}/bin/nvim";

  programs.neovim = {
    enable = true;

    package = pkgs.neovim-unwrapped;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withRuby = true;
    withPython3 = true;
    withNodeJs = true;

    extraPackages = [
      # For nvim :checkhealth to be happy with the tree-sitter setup
      pkgs.gcc
      pkgs.tree-sitter

      # CLI Linters
      pkgs.nodePackages.eslint
      pkgs.nodePackages.htmlhint
      pkgs.nodePackages.jsonlint
      pkgs.nodePackages.stylelint
      pkgs.python3Packages.isort
      pkgs.python3Packages.flake8
      pkgs.python3Packages.flake8-import-order
      pkgs.python3Packages.yamllint
      pkgs.shellcheck
      pkgs.vim-vint

      # Language Servers
      lsp.dot-language-server
      lsp.stylelint-lsp
      lsp.typescript-language-server
      lsp.vim-language-server
      lsp.vscode-langservers-extracted
      pkgs.gopls
      pkgs.nimlsp
      pkgs.nodePackages.bash-language-server
      pkgs.nodePackages.diagnostic-languageserver
      pkgs.nodePackages.dockerfile-language-server-nodejs
      pkgs.nodePackages.pyright
      pkgs.nodePackages.yaml-language-server
      pkgs.rnix-lsp
      pkgs.rust-analyzer-unwrapped
      pkgs.solargraph
      pkgs.terraform-ls
    ];

    plugins = [
      pkgs.vimPlugins.editorconfig-vim
      pkgs.vimPlugins.vim-gitgutter
      pkgs.vimPlugins.vim-polyglot
      pkgs.vimPlugins.lsp-status-nvim
      pkgs.vimPlugins.lsp-colors-nvim
      {
        plugin = pkgs.vimPlugins.completion-nvim;
        config = ''
          let g:completion_enable_snippet = 'snippets.nvim'
        '';
      }
      {
        plugin = pkgs.vimPlugins.snippets-nvim;
        config = builtins.readFile ../configs/nvim/snippets.vim;
      }
      {
        plugin = pkgs.vimPlugins.gruvbox-community;
        config = ''
        set background=dark
        colorscheme gruvbox
        '';
      }
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        config = builtins.readFile ../configs/nvim/lspconfig.vim;
      }
      {
        plugin = (pkgs.vimPlugins.nvim-treesitter.withPlugins (
          plugins: [
            pkgs.vimPlugins.nvim-treesitter-context
            pkgs.vimPlugins.nvim-treesitter-refactor

            # completion-nvim is dep of completion-treesitter
            pkgs.vimPlugins.completion-treesitter
          ]
        ));

        config = builtins.readFile ../configs/nvim/treesitter.vim;
      }
    ];

    extraConfig = builtins.readFile ../configs/nvim/init.nvim;
  };
}
