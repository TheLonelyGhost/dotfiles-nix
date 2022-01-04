{ pkgs ? import <nixpkgs> {} }:

let
  version = "3.0.2";
  deps = [
    pkgs.git
    pkgs.gcc
    pkgs.sqlite
  ];
in
pkgs.buildGoModule {
  pname = "buffalo-plugin-pop";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "gobuffalo";
    repo = "buffalo-pop";
    rev = "v${version}";
    sha256 = "sha256-Re7ik04WLUZAzJfXl2hODZq37p2QJICX7PDIMgYm76A=";
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

  vendorSha256 = "sha256-NKNSiUAgrQNzeOKPFhvMwxTfmgSydfHAIBqZMknO8g8=";

  # subPackages = ["cmd/buffalo"];

  postInstall = ''
    cp -r "$GOPATH" "$out"
    wrapProgram $out/bin/buffalo-pop --argv0 buffalo-pop \
      --set-default GO_BIN ${pkgs.go}/bin/go \
      --suffix PATH : ${pkgs.lib.makeBinPath deps}
  '';
}
