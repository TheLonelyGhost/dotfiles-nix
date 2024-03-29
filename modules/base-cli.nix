{ pkgs, workstation-deps, homeDirectory, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  home.packages = [
    pkgs.coreutils
    pkgs.nix-doc
    pkgs.statix
    workstation-deps.pbcopy
    workstation-deps.pbpaste
  ];
  home.sessionPath = [
    "${homeDirectory}/.local/bin"
  ];

  programs.bat = {
    enable = true;
    config = {
      pager = "${pkgs.less}/bin/less --quit-if-one-screen --RAW-CONTROL-CHARS";
      theme = "TwoDark";
    };
  };

  programs.zsh.shellAliases.cat = "${pkgs.bat}/bin/bat";

  xdg.configFile."configstore/update-notifier-netlify-cli.json".text = ''
  {
    "optOut": true
  }
  '';
}
