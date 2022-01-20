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

    withRuby = false;
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
      lsp.scry

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
      {
        plugin = pkgs.vimPlugins.editorconfig-vim;
      }
      {
        plugin = pkgs.vimPlugins.vim-gitgutter;
      }
      {
        plugin = pkgs.vimPlugins.vim-polyglot;
      }
      {
        plugin = pkgs.vimPlugins.nvim-treesitter-refactor;
        config = ''
          " nvim-treesitter-refactor: ${pkgs.vimPlugins.nvim-treesitter-refactor}
        '';
      }
      {
        plugin = pkgs.vimPlugins.nvim-treesitter-context;
        config = ''
          lua <<EOH
          require'treesitter-context'.setup {
            enable = true,
            throttle = true,
            max_lines = 0, -- how many lines the window should span (Values <= 0 means no limit)
          }
          EOH
        '';
      }
      {
        plugin = pkgs.vimPlugins.nvim-treesitter;

        config = ''
          lua <<EOH
          require'nvim-treesitter.configs'.setup {
            refactor = {
              highlight_definitions = { enable = true },
              smart_rename = {
                enable = true,
                keymaps = {
                  smart_rename = "grr",
                },
              },
              navigation = {
                enable = true,
                keymaps = {
                  goto_definition_lsp_fallback = "gnd",
                  list_definitions = "gnD",
                  list_definitions_toc = "gO",
                  goto_next_usage = "<a-*>",
                  goto_previous_usage = "<a-#>",
                },
              },
            },
          }
          EOH
        '';
      }
      {
        plugin = pkgs.vimPlugins.vim-vsnip;
      }
      {
        plugin = pkgs.vimPlugins.vim-vsnip-integ;
      }
      {
        plugin = pkgs.vimPlugins.cmp-buffer;
      }
      {
        plugin = pkgs.vimPlugins.cmp-cmdline;
      }
      {
        plugin = pkgs.vimPlugins.cmp-path;
      }
      {
        plugin = pkgs.vimPlugins.cmp-nvim-lsp;
      }
      {
        plugin = pkgs.vimPlugins.nvim-cmp;
        config = ''
          " Handy stuff to display autocompletion, but not autoinsert
          set completeopt=menuone,noinsert,noselect

          " Skip entries related to insert completion menu events in `:messages`
          set shortmess+=c

          lua <<EOH
          local cmp = require'cmp'

          cmp.setup({
            snippet = {
              expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
              end,
            },
            -- mapping = {
            -- },
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'vsnip' },
            }, {
              { name = 'buffer' },
            }),
          })
          EOH
        '';
      }
      {
        plugin = pkgs.vimPlugins.lsp-status-nvim;
        config = ''
          " lsp-status
        '';
      }
      {
        plugin = pkgs.vimPlugins.gruvbox-community;
        config = ''
          let g:gruvbox_contrast_dark = 'hard'
          if exists('+termguicolors')
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum;"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum;"
          endif
          let g:gruvbox_invert_selection = '0'
          colorscheme gruvbox
          set background=dark
        '';
      }
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        config = builtins.readFile ../configs/nvim/lspconfig-before.vim + ''
        -- Bash
        nvim_lsp.bashls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.bash-language-server}/bin/bash-language-server', 'start' },
        }

        -- Crystal
        nvim_lsp.scry.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.scry}/bin/scry' },
        }

        -- CSS / SCSS
        nvim_lsp.stylelint_lsp.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.stylelint-lsp}/bin/stylelint-lsp', '--stdio' },
        }

        -- Graphviz (dot)
        nvim_lsp.dotls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.dot-language-server}/bin/dot-language-server', '--stdio' },
        }

        -- Docker
        nvim_lsp.dockerls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.dockerfile-language-server}/bin/docker-langserver', '--stdio' },
        }

        -- Go
        nvim_lsp.gopls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.gopls}/bin/gopls' },
        }

        -- HTML
        nvim_lsp.html.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.vscode-langservers-extracted}/bin/vscode-html-language-server', '--stdio' },
        }

        -- JSON
        nvim_lsp.jsonls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.vscode-langservers-extracted}/bin/vscode-json-language-server', '--stdio' },
        }

        -- Nim
        nvim_lsp.nimls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.nim-language-server}/bin/nimlsp', '--stdio' },
        }

        -- Nix
        nvim_lsp.rnix.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.nix-language-server}/bin/rnix-lsp' },
        }

        -- Python
        nvim_lsp.pyright.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.pyright}/bin/pyright-langserver', '--stdio' },
        }

        -- Ruby
        nvim_lsp.solargraph.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.solargraph}/bin/solargraph', 'stdio' },
        }

        -- Rust
        nvim_lsp.rust_analyzer.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.rust-analyzer}/bin/rust-analyzer' },
        }

        -- Terraform
        nvim_lsp.terraformls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.terraform-language-server}/bin/terraform-ls', 'serve' },
        }

        -- TypeScript
        nvim_lsp.tsserver.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.typescript-language-server}/bin/typescript-language-server', '--stdio' },
        }

        -- Vim
        nvim_lsp.vimls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.vim-language-server}/bin/vim-language-server', '--stdio' },
        }

        -- YAML
        nvim_lsp.yamlls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = { '${lsp.yaml-language-server}/bin/yaml-language-server', '--stdio' },
        }

        -- Everything Else
        nvim_lsp.diagnosticls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = {"${lsp.diagnostic-language-server}/bin/diagnostic-languageserver", "--stdio"},
          filetypes = {
            "sh"
          },
          init_options = {
            linters = {
              shellcheck = {
                command = "shellcheck",
                debounce = 100,
                args = {
                  "--format=json",
                  "-"
                },
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "shellcheck",
                formatLines = 1,
                parseJson = {
                  sourceName = "file",
                  -- sourceNameFilter = true,
                  line = "line",
                  column = "column",
                  endLine = "endLine",
                  endColumn = "endColumn",
                  message = "''${message} [SC''${code}]",
                  security = "level"
                },
                securities = {
                  error = "error",
                  warning = "warning",
                  note = "info",
                  style = "hint"
                }
              }
            },
            filetypes = {
              sh = "shellcheck"
            }
          }
        }
        '' + builtins.readFile ../configs/nvim/lspconfig-after.vim;
      }
    ];

    extraConfig = ''
      " packloadall

      augroup vimrcEx
        autocmd!

        " When editing a file, always jump to the last known cursor position.
        " Don't do it for commit messages, when the position is invalid, or when
        " inside an event handler (happens when dropping a file on gvim).
        autocmd BufReadPost *
              \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
              \   exe "normal g`\"" |
              \ endif

        autocmd BufReadPost .envrc
              \ set ft=sh

      augroup END

      set number
    '';
  };
}
