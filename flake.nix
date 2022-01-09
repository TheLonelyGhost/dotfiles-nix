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

    lsp.url = "github:thelonelyghost/lsp-nix";
    workstation-deps.url = "github:thelonelyghost/workstation-deps-nix";
    golang-webdev.url = "github:thelonelyghost/golang-webdev-nix";

    zsh-plugin-syntax-highlight = {
      url = "github:zdharma-continuum/fast-syntax-highlighting";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-compat, flake-utils, lsp, workstation-deps, golang-webdev, zsh-plugin-syntax-highlight }:
    let
      stateVersion = "21.11";
      commitEmail = "opensource@thelonelyghost.com";
    in
    {
      homeConfigurations = {
        "thelonelyghost@DESKTOP-9R2I02I" = home-manager.lib.homeManagerConfiguration (let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          system = "x86_64-linux";
          username = "thelonelyghost";
          homeDirectory = "/home/thelonelyghost";
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
            isWSL = true;
            isLinux = pkgs.stdenv.isLinux;

            inherit system username homeDirectory commitEmail;
            hostname = "DESKTOP-9R2I02I";
            windowsHome = "/mnt/c/Users/david";

            lsp = lsp.outputs.packages."x86_64-linux";
            workstation-deps = workstation-deps.packages."x86_64-linux";
            golang-webdev = golang-webdev.outputs.packages."x86_64-linux";
            inherit zsh-plugin-syntax-highlight;
          };

          inherit stateVersion system username homeDirectory;
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
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.bashInteractive
            pkgs.gnumake
          ];
        };
      }
    ));
}
