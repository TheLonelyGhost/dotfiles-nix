{ pkgs, config, lib, ... }:

let
  #
in
pkgs.buildGoPackage rec {
  pname = "tag";
  version = "1.4.0";
  goPackagePath = "github.com/aykamko/tag";
  goDeps = ./deps.nix;

  src = pkgs.fetchFromGitHub {
    owner = "aykamko";
    repo = "tag";
    # ref = "v1.4.0";
    rev = "a1f5b04ac5664530afbfefad37bbb50286ec3fd5";
    sha256 = "1pz9hm7isqj18fvv36z14b4q0alj5nrff9h6p5qk5vvgvxnijr3w";
  };

  meta = {
    description = "Alias support to allow ripgrep to easily open matches to the exact line and column in which they occur";
    homepage = "https://github.com/aykamko/tag";
    license = lib.licenses.mit;
  };
}
