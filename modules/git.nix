{ system, config, home, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  homeDir = builtins.getEnv "HOME";

  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in
{
  home.packages = [
    pkgs.ghq
  ];

  programs.gh = {
    enable = true;
    editor = "${pkgs.neovim-unwrapped}/bin/nvim";
    gitProtocol = "ssh";
  };

  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "David Alexander";
    userEmail = "opensource@thelonelyghost.com";

    aliases = {
      camend = "commit --amend --reuse-message HEAD";
      ci = "commit -v";
      co = "checkout";
      contributors = "shortlog --summary --numbered";
      current-branch = "rev-parse --abbrev-ref HEAD";
      clean-branch = "checkout --orphan";
      pf = "push --force-with-lease";

      ls-tags = "tags --list -n1";

      ignore = "!f() { ${pkgs.curl}/bin/curl https://www.toptal.com/developers/gitignore/api/$(${pkgs.perl}/bin/perl -e 'print join(\",\", @ARGV);' \"$@\";) | ${pkgs.coreutils}/bin/tee .gitignore; };f";
    };

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      ghq = {
        root = "${homeDir}/workspace";
      };
      pull = {
        rebase = true;
      };
    };

    ignores = [
      ".direnv/"
      ".envrc"
      # "shell.nix"
      ".DS_Store"
      "[Tt]humbs.db"
      "*.sw[nop]"
      "*.sqlite3"
      "*.pyc"
      "*.egg-info"
      ".eggs/"
      "__pycache__"
      ".pytest_cache"
      ".mypy_cache"
      "*.log"
      "tmp/"
    ];
  };

  home.file.".local/bin/g" = {
    source = pkgs.writeScript "g" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    "${pkgs.gnupg}/bin/gpg-connect-agent" updatestartuptty /bye 1>/dev/null

    if [ $# -gt 0 ]; then
      "${pkgs.git}/bin/git" "$@"
    else
      "${pkgs.git}/bin/git" status -sb
    fi
    '';
    executable = true;
  };
}
