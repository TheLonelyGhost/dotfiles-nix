{ config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  homeDir = builtins.getEnv "HOME";
  username = builtins.getEnv "USER";

  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixpkgs {};

  windowsHome = "/mnt/c/Users/david";
  npiperelay_exe = "${windowsHome}/.wsl/npiperelay.exe";
in
{
  home.file.".zsh/config/ssh-agent.zsh" = {
    text = ''
    export SSH_AUTH_SOCK='${homeDir}/.ssh/agent.sock'

    if [ -e "''${SSH_AUTH_SOCK}" ] && ! ${pkgs.socat}/bin/socat -u OPEN:/dev/null UNIX-CONNECT:"''${SSH_AUTH_SOCK}" 1>/dev/null 2>&1; then
      rm "''${SSH_AUTH_SOCK}"
    fi

    if ! [ -e "''${SSH_AUTH_SOCK}" ]; then
      ( setsid ${pkgs.socat}/bin/socat UNIX-LISTEN:"''${SSH_AUTH_SOCK}",fork EXEC:"${npiperelay_exe} -ei -s //./pipe/openssh-ssh-agent",nofork & ) &>/dev/null
    fi
    '';
  };
}
