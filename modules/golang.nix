{ config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};

  revel = pkgs.callPackage ../packages/revel.nix {};
in
{
  home.packages = [
    revel
  ];
}

