{ pkgs, neovim, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  home.sessionVariables.EDITOR = "${neovim.neovim}/bin/nvim";
  home.sessionVariables.VISUAL = "${neovim.neovim}/bin/nvim";

  home.packages = [
    neovim.neovim
  ];
}
