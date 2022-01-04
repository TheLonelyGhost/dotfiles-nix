{ system, config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

rec {
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "21.11";

  programs.home-manager.enable = true;

  home.sessionPath = [
    "${home.homeDirectory}/.local/bin"
  ];
}
