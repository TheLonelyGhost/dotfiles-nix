{ pkgs, workstation-deps, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  home.packages = [
    workstation-deps.tat
  ];

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

    plugins = [
      # tmuxPlugins.sensible  # Broken
      pkgs.tmuxPlugins.cpu
      pkgs.tmuxPlugins.battery
      {
        plugin = pkgs.tmuxPlugins.gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox 'dark'
        '';
      }
      pkgs.tmuxPlugins.pain-control
      pkgs.tmuxPlugins.sidebar
      pkgs.tmuxPlugins.yank
    ];
  };
}
