{ pkgs, isWSL, workstation-deps, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  home.packages = [
    pkgs.openssh
  ];
  home.file.".zsh/config/ssh-agent.zsh".text = pkgs.lib.optionalString isWSL ''
  eval "$(${workstation-deps.wsl-ssh-agent-relay}/bin/ssh-relay)"
  '';
}
