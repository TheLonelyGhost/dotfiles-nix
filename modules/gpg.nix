{ system, config, home, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in
{
  home.packages = [];

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "tty";
  };

  programs.git.signing.signByDefault = true;
  programs.git.signing.key = null;
}
