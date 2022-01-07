{ config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};

  golang-webdev = (import (pkgs.fetchFromGitHub { inherit (sources.golang-webdev) owner repo rev sha256; })).outputs.packages."${builtins.currentSystem}";
in
{
  home.packages = [
    golang-webdev.buffalo
    golang-webdev.buffalo-plugin-heroku
  ];

  home.file.".buffalo.yml".text = ''
  ---
  db-type: sqlite3
  '';
}
