{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11-small";
    overlays.url = "github:thelonelyghost/blank-overlay-nix";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "flake:flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    neovim = {
      url = "https://flakehub.com/f/TheLonelyGhost/neovim/*.tar.gz";
      inputs = {
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
        overlays.follows = "overlays";
      };
    };
    workstation-deps = {
      url = "github:thelonelyghost/workstation-deps-nix";
      inputs = {
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
        overlays.follows = "overlays";
      };
    };

    zsh-plugin-syntax-highlight.url = "github:zdharma-continuum/fast-syntax-highlighting";
    zsh-plugin-syntax-highlight.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, flake-compat, flake-utils, overlays, neovim, workstation-deps, zsh-plugin-syntax-highlight }:
    let
      baseConfig = import ./libs/baseConfig.nix {
        /* Flakes that need resolving per system */
        inherit nixpkgs home-manager flake-compat flake-utils neovim workstation-deps overlays;
      } {
        /* Non-Flake flakes */
        inherit zsh-plugin-syntax-highlight;
      };
    in
    {
      homeConfigurations = {
        "thelonelyghost@TLG-DESKTOP" = home-manager.lib.homeManagerConfiguration (baseConfig {
          fullName = "David Alexander";
          commitEmail = "opensource@thelonelyghost.com";

          system = "x86_64-linux";
          hostname = "TLG-DESKTOP";
          username = "thelonelyghost";

          windowsUsername = "thelonelyghost";
        });

        "thelonelyghost@DESKTOP-9R2I02I" = home-manager.lib.homeManagerConfiguration (baseConfig {
          system = "x86_64-linux";
          fullName = "David Alexander";
          commitEmail = "opensource@thelonelyghost.com";
          hostname = "DESKTOP-9R2I02I";
          username = "thelonelyghost";
          windowsUsername = "david";
        });
      };
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        # This is a placeholder for anything helpful when developing the flake:
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.bashInteractive
            pkgs.gnumake
            pkgs.statix
            pkgs.jq
          ];

          STATIX = "${pkgs.statix}/bin/statix";
        };
      }
    ));
}
