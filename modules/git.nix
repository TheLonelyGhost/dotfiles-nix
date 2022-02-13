{ pkgs, commitEmail, neovim, homeDirectory, workstation-deps, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  home.packages = [
    pkgs.ghq
    workstation-deps.g
    workstation-deps.git-ignore
  ];

  programs.gh = {
    enable = true;
    settings.editor = "${neovim.neovim}/bin/nvim";
    settings.git_protocol = "ssh";
  };

  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "David Alexander";
    userEmail = commitEmail;

    aliases = {
      camend = "commit --amend --reuse-message HEAD";
      ci = "commit -v";
      co = "checkout";
      contributors = "shortlog --summary --numbered";
      current-branch = "rev-parse --abbrev-ref HEAD";
      clean-branch = "checkout --orphan";
      pf = "push --force-with-lease";

      ls-tags = "tags --list -n1";

      # git-log with diff
      ld = "log --topo-order --stat --patch --full-diff --pretty=format:'%C(bold yellow)Commit:%C(reset) %C(yellow)%H%C(red)%d%C(reset)%n%C(bold yellow)Author:%C(reset) %C(cyan)%an <%ae>%C(reset)[%C(dim yellow)%GS%C(reset)|%C(green)%G?%C(reset)]%n%C(bold yellow)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'";

      lol = "log --graph --decorate --oneline";
      lola = "log --graph --decorate --oneline --all";
    };

    extraConfig = {
      init.defaultBranch = "main";
      ghq.root = "${homeDirectory}/workspace";
      pull.rebase = true;

      branch.master.rebase = true;
      branch.main.rebase = true;

      fetch.prune = true;

      rebase = {
        autoSquash = true;
        autoStash = true;
      };

      rerere.enabled = true;
      status.submodulesummary = true;
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
