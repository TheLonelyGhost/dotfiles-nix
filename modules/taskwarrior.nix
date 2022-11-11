{ pkgs, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  home.packages = [
    pkgs.taskwarrior
    pkgs.timewarrior
    pkgs.python3Packages.bugwarrior
  ];

  # xdg.configFile."taskwarrior/taskwarriorrc".text = ''
  # '';
}
