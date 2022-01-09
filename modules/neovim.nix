{ pkgs, lsp, ... }:
# vim: ts=2 sts=2 sw=2 et

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
      lsp.eslint
      lsp.htmlhint
      lsp.jsonlint
      lsp.stylelint
      lsp.isort
      lsp.flake8
      lsp.flake8-import-order
      lsp.yamllint
      lsp.shellcheck
      lsp.vint

      # Language Servers
      lsp.dot-language-server
      lsp.stylelint-lsp
      lsp.typescript-language-server
      lsp.vim-language-server
      lsp.vscode-langservers-extracted

      lsp.gopls
      lsp.nim-language-server
      lsp.bash-language-server
      lsp.diagnostic-language-server
      lsp.dockerfile-language-server
      lsp.pyright
      lsp.yaml-language-server
      lsp.nix-language-server
      lsp.rust-analyzer
      lsp.solargraph
      lsp.terraform-language-server
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
