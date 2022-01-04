{ config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};

  buffalo = pkgs.callPackage ../packages/buffalo.nix {
    inherit pkgs;
  };
  buffaloPlugins = {
    pop = pkgs.callPackage ../packages/buffalo-pop.nix { inherit pkgs; };
    heroku = pkgs.callPackage ../packages/buffalo-heroku.nix { inherit pkgs; };
  };
in
{
  home.packages = [
    buffalo
    buffaloPlugins.heroku
  ];

  home.file.".buffalo.yml".text = ''
  ---
  db-type: sqlite3
  '';

  # home.sessionPath = [
  #   "${builtins.getEnv "HOME"}/go/bin"
  # ];
}

