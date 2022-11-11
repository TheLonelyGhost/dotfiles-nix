{ pkgs, workstation-deps, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  home.packages = [
    pkgs.ripgrep
    workstation-deps.tag
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
  tag() { ${workstation-deps.tag}/bin/tag "$@"; source ''${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
  '';
}
