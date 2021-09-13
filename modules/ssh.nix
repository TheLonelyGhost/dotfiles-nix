{ system, config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};

  isWSL = pkgs.lib.pathExists /mnt/c/Windows/System32;
in
{
  imports = pkgs.lib.optionals isWSL [
    ./wsl/ssh-agent.nix
  ];

  home.packages = [
    pkgs.openssh
  ];
}
