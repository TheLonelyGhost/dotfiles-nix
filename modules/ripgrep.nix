{ system, config, lib, ... }:
# vim: ts=2 sts=2 sw=2 et

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs {};

  tag = pkgs.callPackage ../packages/tag {};
in
{
  home.packages = [
    pkgs.ripgrep
    # tag
  ];

  home.file.".ripgreprc".text = ''
  --follow
  --pcre2
  --trim
  --smart-case
  '';
  programs.zsh.shellAliases.rg = "tag";  # TODO: Nixify this a bit better

  home.file.".zsh/config/tag.zsh".text = ''
  # TODO: Nix-ify this later
  export TAG_SEARCH_PROG='rg' # This must be 'rg' and not the absolute path, because of tag's limitations
  tag() { ${tag}/bin/tag "$@"; source ''${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
  '';
}
