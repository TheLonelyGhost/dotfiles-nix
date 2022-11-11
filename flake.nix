{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    # neovim.url = "path:/home/thelonelyghost/workspace/github.com/thelonelyghost/neovim-nix";
    neovim.url = "github:thelonelyghost/neovim-nix";
    workstation-deps.url = "github:thelonelyghost/workstation-deps-nix";
    golang-webdev.url = "github:thelonelyghost/golang-webdev-nix";

    zsh-plugin-syntax-highlight.url = "github:zdharma-continuum/fast-syntax-highlighting";
    zsh-plugin-syntax-highlight.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, flake-compat, flake-utils, neovim, workstation-deps, golang-webdev, zsh-plugin-syntax-highlight }:
    let
      baseConfig = import ./baseConfig.nix {
        /* Flakes that need resolving per system */
        inherit nixpkgs home-manager flake-compat flake-utils neovim workstation-deps golang-webdev;
      } {
        /* Non-Flake flakes */
        inherit zsh-plugin-syntax-highlight;
      };
    in
    {
      homeConfigurations = {
        "thelonelyghost@TLG-DESKTOP" = home-manager.lib.homeManagerConfiguration (
          let
            fullName = "David Alexander";
            commitEmail = "opensource@thelonelyghost.com";

            system = "x86_64-linux";
            hostname = "TLG-DESKTOP";
            username = "thelonelyghost";
            homeDirectory = "/home/${username}";

            windowsUsername = "thelonelyghost";
          in
          baseConfig {
            inherit system fullName commitEmail hostname username homeDirectory windowsUsername;
          }
        );

        "thelonelyghost@DESKTOP-9R2I02I" = home-manager.lib.homeManagerConfiguration (
          let
            fullName = "David Alexander";
            commitEmail = "opensource@thelonelyghost.com";

            system = "x86_64-linux";
            hostname = "DESKTOP-9R2I02I";
            username = "thelonelyghost";
            homeDirectory = "/home/${username}";

            windowsUsername = "david";
          in
          baseConfig {
            inherit system fullName commitEmail hostname username homeDirectory windowsUsername;
          }
        );
      };
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        # This is a placeholder for anything helpful when developing the flake:
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.bashInteractive
            pkgs.gnumake
          ];
        };
      }
    ));
}
