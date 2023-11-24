{ pkgs, neovim, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  home.sessionVariables = {
    EDITOR = "${neovim.neovim}/bin/nvim";
    VISUAL = "${neovim.neovim}/bin/nvim";
  };

  xdg.configFile."nvim/init.vim".text = ''
  " This file is not observed. Instead modify neovim
  " configuration determined in ~/.config/nixpkgs
  '';

  home.packages = [
    neovim.neovim
  ];
}
