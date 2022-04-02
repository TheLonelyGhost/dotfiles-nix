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

    neovim-nix.url = "github:thelonelyghost/neovim-nix";
    workstation-deps.url = "github:thelonelyghost/workstation-deps-nix";
    golang-webdev.url = "github:thelonelyghost/golang-webdev-nix";

    zsh-plugin-syntax-highlight = {
      url = "github:zdharma-continuum/fast-syntax-highlighting";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-compat, flake-utils, neovim-nix, workstation-deps, golang-webdev, zsh-plugin-syntax-highlight }:
    let
      stateVersion = "21.11";
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
            homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

            windowsUsername = "thelonelyghost";
          in
          {
            configuration = { pkgs, homeDirectory, ... }: {
              programs.home-manager.enable = true;

              imports = [
                ./modules/dev-cli.nix
                ./modules/direnv.nix
                ./modules/neovim.nix
                ./modules/git.nix
                ./modules/golang.nix
                ./modules/gpg.nix
                ./modules/ripgrep.nix
                ./modules/ssh.nix
                ./modules/wsl/ssh-agent.nix
                ./modules/wsl/keepassxc.nix
                ./modules/starship.nix
                ./modules/linux/starship.nix
                ./modules/tmux.nix
                ./modules/zsh.nix
              ];

              home.sessionPath = [
                "${homeDirectory}/.local/bin"
              ];

            };

            inherit pkgs;

            extraSpecialArgs = {
              isWSL = windowsUsername != "";
              inherit (pkgs.stdenv) isLinux isDarwin;

              inherit system hostname username homeDirectory fullName commitEmail windowsUsername;
              windowsHome = if windowsUsername != "" then "/mnt/c/Users/${windowsUsername}" else "";

              neovim = neovim-nix.packages."${system}";
              workstation-deps = workstation-deps.packages."${system}";
              golang-webdev = golang-webdev.outputs.packages."${system}";
              inherit zsh-plugin-syntax-highlight;
            };

            inherit stateVersion system username homeDirectory;
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
            homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

            windowsUsername = "david";
          in
          {
            configuration = { pkgs, homeDirectory, ... }: {
              programs.home-manager.enable = true;

              imports = [
                ./modules/dev-cli.nix
                ./modules/direnv.nix
                ./modules/neovim.nix
                ./modules/git.nix
                ./modules/golang.nix
                ./modules/gpg.nix
                ./modules/ripgrep.nix
                ./modules/ssh.nix
                ./modules/wsl/ssh-agent.nix
                ./modules/wsl/keepassxc.nix
                ./modules/starship.nix
                ./modules/linux/starship.nix
                ./modules/tmux.nix
                ./modules/zsh.nix
              ];

              home.packages = [
                pkgs.flyctl
              ];

              home.sessionPath = [
                "${homeDirectory}/.local/bin"
              ];

            };

            inherit pkgs;

            extraSpecialArgs = {
              isWSL = windowsUsername != "";
              inherit (pkgs.stdenv) isLinux isDarwin;

              inherit system hostname username homeDirectory fullName commitEmail windowsUsername;
              windowsHome = if windowsUsername != "" then "/mnt/c/Users/${windowsUsername}" else "";

              neovim = neovim-nix.packages."${system}";
              workstation-deps = workstation-deps.packages."${system}";
              golang-webdev = golang-webdev.outputs.packages."${system}";
              inherit zsh-plugin-syntax-highlight;
            };

            inherit stateVersion system username homeDirectory;
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
