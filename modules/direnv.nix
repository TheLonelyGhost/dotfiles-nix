{ system, config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in
{
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
    config = {
      global = {
        strict_env = true;
        warn_timeout = "90s";
      };
    };
    # stdlib = ''
    # '';
  };
}
