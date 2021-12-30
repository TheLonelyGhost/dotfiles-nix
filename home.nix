{ config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};

  isWSL = pkgs.lib.pathExists /mnt/c/Windows/System32;
in
{
  imports = [
    ./modules/home-manager.nix

    # ./modules/aws.nix
    ./modules/dev-cli.nix
    ./modules/direnv.nix
    ./modules/git.nix
    ./modules/golang.nix
    ./modules/gpg.nix
    ./modules/neovim.nix
    ./modules/ripgrep.nix
    ./modules/ssh.nix
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/zsh.nix
  ];

  home.packages = pkgs.lib.optionals (!isWSL && pkgs.stdenv.isLinux) [
    # This is generally better to install on the Windows side and execute from within WSL
    pkgs.keepassx-community
  ];
}
