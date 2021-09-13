{ system, config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in
{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    newSession = false;
    prefix = "C-Space";

    escapeTime = 10;
    terminal = "screen-256color";

    extraConfig = ''
    # Renumber windows sequentially after closing any of them
    set-option -g renumber-windows on

    # Switch tmux sessions
    bind-key Enter choose-tree -s -O name

    # Enable termguicolors in neovim
    set-option -sa terminal-overrides ',xterm-256color:RGB'
    '';

    plugins = with pkgs; [
      # tmuxPlugins.sensible  # Broken
      tmuxPlugins.cpu
      tmuxPlugins.battery
      {
        plugin = tmuxPlugins.gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox 'dark'
        '';
      }
      tmuxPlugins.pain-control
      tmuxPlugins.sidebar
      tmuxPlugins.yank
    ];
  };

  home.file.".local/bin/tat" = {
    text = builtins.readFile ../configs/tmux/tat;
    executable = true;
  };

}
