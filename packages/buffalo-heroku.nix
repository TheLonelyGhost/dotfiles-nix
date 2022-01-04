{ pkgs ? import <nixpkgs> {} }:

let
  version = "1.0.9";
  deps = [
    pkgs.git
  ];
in
pkgs.buildGoModule {
  pname = "buffalo-plugin-heroku";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "gobuffalo";
    repo = "buffalo-heroku";
    rev = "v${version}";
    sha256 = "sha256-z6ceKjkOFfDPUTIw0YNgt5LC/S6DYLyyaelU6R8s0Pw=";
  };

  buildInputs = [
    pkgs.makeWrapper
  ] ++ deps;

  # buildFlags = "-tags sqlite";

  # allowGoReference = true;

  # This is purely because tests require internet access to clone
  # down repos and the build env cuts that off to track actual
  # dependencies, as declared in this derivation, reflect reality
  # doCheck = false;

  vendorSha256 = "sha256-U3xjMDCP53wa8VU7w2o4y0CnoFbjzGZuGmTLVx90HSw=";

  # subPackages = ["cmd/buffalo"];

  postInstall = ''
    cp -r "$GOPATH" "$out"
    wrapProgram $out/bin/buffalo-heroku --argv0 buffalo-heroku \
      --suffix PATH : ${pkgs.lib.makeBinPath deps}
  '';
}
