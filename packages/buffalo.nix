{ pkgs ? import <nixpkgs> {}, nodejs ? pkgs.nodejs-16_x, yarn ? pkgs.yarn }:

let
  buffalo-pop = pkgs.callPackage ./buffalo-pop.nix {
    inherit pkgs;
  };

  version = "0.18.1";
  deps = [
    pkgs.git
    pkgs.gcc
    pkgs.sqlite
    nodejs
    yarn
    buffalo-pop
  ];
in
pkgs.buildGoModule {
  pname = "buffalo";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "gobuffalo";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-DqZGzVRMp/yNPRWzp8zVRJqJ4jon5g5uGEsV9GRn8CE=";
  };

  buildInputs = [
    pkgs.makeWrapper
  ] ++ deps;

  buildFlags = "-tags sqlite";

  allowGoReference = true;

  # This is purely because tests require internet access to clone
  # down repos and the build env cuts that off to track actual
  # dependencies, as declared in this derivation, reflect reality
  # doCheck = false;

  vendorSha256 = "sha256-ZEEGvNcDQAjZOIuQyeE5v6+1TTsHYMRni8Fuj+feups=";

  # subPackages = ["cmd/buffalo"];

  postInstall = ''
    cp -r "$GOPATH" "$out"
    wrapProgram $out/bin/buffalo --argv0 buffalo \
      --set-default GO_BIN ${pkgs.go}/bin/go \
      --suffix PATH : ${pkgs.lib.makeBinPath deps}
  '';
}
