{ pkgs, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = !pkgs.stdenv.isDarwin;
    pinentryFlavor = "tty";
  };

  programs.git.signing = {
    signByDefault = true;
    key = null;
  };
}
