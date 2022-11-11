{ pkgs, homeDirectory, zsh-plugin-syntax-highlight, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  zsh-fast-syntax-highlighting = {
    name = "zsh-fast-syntax-highlighting";
    src = pkgs.fetchFromGitHub {
      owner = "zdharma-continuum";
      repo = "fast-syntax-highlighting";

      # manage revision and sha256 with flakes
      rev = zsh-plugin-syntax-highlight.rev;
      sha256 = zsh-plugin-syntax-highlight.narHash;
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
    if [ -e "/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
      . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    fi
    if [ -e "${homeDirectory}/.nix-profile/etc/profile.d/nix.sh" ]; then
      . "${homeDirectory}/.nix-profile/etc/profile.d/nix.sh"
    fi
    compdef g=git

    for filename in $(find "${homeDirectory}/.zsh/config" -name '*.zsh' -or -name '*.sh'); do
      source "$filename"
    done

    setopt MARK_DIRS
    setopt INTERACTIVE_COMMENTS

    autoload -z edit-command-line
    zle -N edit-command-line
    bindkey "^X^E" edit-command-line
    '';

    # initExtraBeforeCompInit = ''
    # '';

    initExtraFirst = ''
    zmodload zsh/zprof
    '';
  };
}
