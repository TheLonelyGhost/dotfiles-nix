{ pkgs, golang-webdev, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  home.packages = [
    pkgs.go
    golang-webdev.buffalo
    golang-webdev.buffalo-plugin-heroku
  ];

  home.file.".buffalo.yml".text = ''
  ---
  db-type: sqlite3
  '';
}
