{ pkgs, isWSL, workstation-deps, windowsUsername, ... }:
# vim: ts=2 sts=2 sw=2 et

assert isWSL;
{
  home.file.".zsh/config/keepassxc-relay.zsh" = {
    text = ''
    eval "$(${workstation-deps.wsl-keepassxc-relay}/bin/keepassxc-relay '${windowsUsername}')"
    '';
  };
}
