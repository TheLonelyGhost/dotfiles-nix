{ system, config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in
{
  home.packages = [
    pkgs.coreutils
    pkgs.niv
  ];

  programs.bat = {
    enable = true;
    config = {
      pager = "${pkgs.less}/bin/less --quit-if-one-screen --RAW-CONTROL-CHARS";
      theme = "TwoDark";
    };
  };
  programs.zsh.shellAliases.cat = "${pkgs.bat}/bin/bat";

  home.file.".local/bin/nixify" = {
    text = builtins.readFile ../configs/flakes/nixify;
    executable = true;
  };

  home.file.".local/bin/flakify" = {
    text = builtins.readFile ../configs/flakes/flakify;
    executable = true;
  };
}
