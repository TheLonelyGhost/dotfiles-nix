{ config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  programs.starship.settings.battery.format = "[Batt:$percentage]($style)";
  programs.starship.settings.nodejs.symbol = "JS ";
}
