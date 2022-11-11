{ pkgs, workstation-deps, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  home.packages = [
    workstation-deps.flakify
  ];
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
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

  programs.direnv.enableZshIntegration = true;
}
