{ config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in
{
  home.packages = [
    pkgs.awscli2
    pkgs.saml2aws
  ];
}
