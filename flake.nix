{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    hm-modules-nix.url = "github:thelonelyghost/hm-modules-nix";
    hm-modules-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, flake-compat, flake-utils, hm-modules-nix }:
    let
      stateVersion = "21.11";
      baseConfig = { pkgs, fullName, commitEmail, hostname, username, homeDirectory, windowsUsername ? "" }: let
        system = pkgs.system;
        hm-modules = hm-modules-nix.packages."${system}";
      in {
        configuration = { ... }: {
          programs.home-manager.enable = true;

          imports = [
            hm-modules.base-cli
            hm-modules.direnv
            hm-modules.git
            hm-modules.golang
            hm-modules.gpg
            hm-modules.keepassxc
            hm-modules.neovim
            hm-modules.ripgrep
            hm-modules.ssh
            hm-modules.starship
            hm-modules.tmux
            hm-modules.zsh
          ];
        };

        inherit pkgs;

        extraSpecialArgs = hm-modules.extraSpecialArgs {
          inherit system hostname username homeDirectory fullName commitEmail windowsUsername;
        };

        inherit stateVersion system username homeDirectory;
      };
    in
    {
      homeConfigurations = {
        "thelonelyghost@TLG-DESKTOP" = home-manager.lib.homeManagerConfiguration (
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };

            fullName = "David Alexander";
            commitEmail = "opensource@thelonelyghost.com";

            system = "x86_64-linux";
            hostname = "TLG-DESKTOP";
            username = "thelonelyghost";
            homeDirectory = "/home/${username}";

            windowsUsername = "thelonelyghost";
          in
          baseConfig {
            inherit pkgs fullName commitEmail hostname username homeDirectory windowsUsername;
          }
        );

        "thelonelyghost@DESKTOP-9R2I02I" = home-manager.lib.homeManagerConfiguration (
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };

            fullName = "David Alexander";
            commitEmail = "opensource@thelonelyghost.com";

            system = "x86_64-linux";
            hostname = "DESKTOP-9R2I02I";
            username = "thelonelyghost";
            homeDirectory = "/home/${username}";

            windowsUsername = "david";
          in
          baseConfig {
            inherit pkgs fullName commitEmail hostname username homeDirectory windowsUsername;
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
