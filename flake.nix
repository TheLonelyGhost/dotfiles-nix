{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    overlays.url = "github:thelonelyghost/blank-overlay-nix";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "flake:flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    neovim.url = "github:thelonelyghost/neovim-nix";
    neovim.inputs.flake-utils.follows = "flake-utils";
    neovim.inputs.flake-compat.follows = "flake-compat";
    neovim.inputs.overlays.follows = "overlays";
    workstation-deps.url = "github:thelonelyghost/workstation-deps-nix";
    workstation-deps.inputs.flake-utils.follows = "flake-utils";
    workstation-deps.inputs.flake-compat.follows = "flake-compat";
    workstation-deps.inputs.overlays.follows = "overlays";

    zsh-plugin-syntax-highlight.url = "github:zdharma-continuum/fast-syntax-highlighting";
    zsh-plugin-syntax-highlight.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, flake-compat, flake-utils, overlays, neovim, workstation-deps, zsh-plugin-syntax-highlight }:
    let
      baseConfig = import ./baseConfig.nix {
        /* Flakes that need resolving per system */
        inherit nixpkgs home-manager flake-compat flake-utils neovim workstation-deps overlays;
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
          nativeBuildInputs = [
            pkgs.bashInteractive
            pkgs.gnumake
          ];
        };
      }
    ));
}
