{ pkgs, isLinux, ... }:
# vim: ts=2 sts=2 sw=2 et

assert isLinux;

{
  programs.starship.settings.battery.format = "[Batt:$percentage]($style)";
  programs.starship.settings.nodejs.symbol = "JS ";
}
