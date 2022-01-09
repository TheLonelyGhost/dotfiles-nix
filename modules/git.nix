{ pkgs, homeDirectory, workstation-deps, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  home.packages = [
    pkgs.ghq
    workstation-deps.g
    workstation-deps.git-ignore
  ];

  programs.gh = {
    enable = true;
    settings.editor = "${pkgs.neovim-unwrapped}/bin/nvim";
    settings.git_protocol = "ssh";
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
    };

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      ghq = {
        root = "${homeDirectory}/workspace";
      };
      pull = {
        rebase = true;
      };
    };

    ignores = [
      ".direnv/"
      ".envrc"
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
}
