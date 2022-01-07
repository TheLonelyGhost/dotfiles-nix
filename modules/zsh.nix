{ system, config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  homeDir = builtins.getEnv "HOME";

  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};

  zsh-fast-syntax-highlighting = {
    name = "zsh-fast-syntax-highlighting";
    src = pkgs.fetchFromGitHub {
      owner = "zdharma";
      repo = "fast-syntax-highlighting";
      rev = "817916dfa907d179f0d46d8de355e883cf67bd97";
      sha256 = "0m102makrfz1ibxq8rx77nngjyhdqrm8hsrr9342zzhq1nf4wxxc";
    };
    file = "fast-syntax-highlighting.plugin.zsh";
  };
in
{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    enableCompletion = true;

    plugins = [
      zsh-fast-syntax-highlighting
    ];

    shellAliases = {
      ls = "${pkgs.coreutils}/bin/ls --classify --color=auto";
    };

    initExtra = ''
    compdef g=git

    for filename in $(find "${homeDir}/.zsh/config" -name '*.zsh' -or -name '*.sh'); do
      source "$filename"
    done

    setopt MARK_DIRS
    setopt INTERACTIVE_COMMENTS

    autoload -z edit-command-line
    zle -N edit-command-line
    bindkey "^X^E" edit-command-line
    '';

    initExtraBeforeCompInit = ''
    '';

    initExtraFirst = ''
    zmodload zsh/zprof
    '';
    # Nixpkgs installation (not NixOS)
    # source "${pkgs.nix}/etc/profile.d/nix.sh"

    # export NIX_PATH="${homeDir}/.nix-defexpr/channels''${NIX_PATH:+:}''${NIX_PATH:-}"
    # unset __HM_SESS_VARS_SOURCED
    # '';

    # envExtra = ''
    # # Nix-determined Environment variables
    # source "${homeDir}/.nix-profile/etc/profile.d/hm-session-vars.sh"
    # '';
  };
  programs.direnv.enableZshIntegration = true;
  programs.starship.enableZshIntegration = true;
}
