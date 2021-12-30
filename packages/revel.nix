{ config, pkgs ? import <nixpkgs> {} }:

let
  version = "1.0.3";
in
pkgs.buildGoModule {
  pname = "revel";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "revel";
    repo = "cmd";
    rev = "v${version}";
    sha256 = "sha256-cqwNLhduE2BConeZZ+EanAMC9CvXbn3SjtN7LcU5W7E=";
  };

  # This is purely because tests require internet access and
  # the build env cuts that off to track actual dependencies
  # as declared in this derivation are the same as reality.
  doCheck = false;

  vendorSha256 = "sha256-OZ/XhTU0UPdGnNR9o25ID7TN+9fjAOT8YAfc8pvM28c=";

  subPackages = ["revel"];
}
