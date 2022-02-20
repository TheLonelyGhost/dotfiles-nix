{ pkgs, isWSL, workstation-deps, ... }:
# vim: ts=2 sts=2 sw=2 et

assert isWSL;
{
  home.file.".zsh/config/ssh-agent.zsh" = {
    text = ''
    eval "$(${workstation-deps.wsl-ssh-agent-relay}/bin/ssh-relay)"
    '';
  };
}
