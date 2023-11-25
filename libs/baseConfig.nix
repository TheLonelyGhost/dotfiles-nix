flakes:

nonFlakes:

/* On each workstation, pass these items: */
{ system, fullName, commitEmail, hostname, username, homeDirectory ? "/home/${username}", windowsUsername ? "" }:

let
  /* Flakes -> Package bundles */
  pkgs = import flakes.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [flakes.overlays.overlays.default];
  };
  neovim = flakes.neovim.packages."${system}";
  workstation-deps = flakes.workstation-deps.packages."${system}";
  golang-webdev = flakes.golang-webdev.packages."${system}";

  /* Non-Flakes -> (noop) */
  inherit (nonFlakes) zsh-plugin-syntax-highlight;

  /* Libs */

in
{

  modules = [
    {
      programs.home-manager.enable = true;

      home = {
        inherit username homeDirectory;
        stateVersion = "22.11";

        # TODO: Investigate later
        packages = [
          # pkgs.csvkit
        ];
      };
    }
    ../modules/base-cli.nix
    ../modules/direnv.nix
    ../modules/git.nix
    ../modules/golang.nix
    ../modules/gpg.nix
    ../modules/keepassxc.nix
    ../modules/neovim.nix
    ../modules/ripgrep.nix
    ../modules/ssh.nix
    ../modules/starship.nix
    ../modules/tmux.nix
    ../modules/zsh.nix
    # TODO:
    # ../modules/taskwarrior.nix
  ];

  inherit pkgs;

  extraSpecialArgs = import ./extraArgs.nix
    {
      inherit pkgs neovim workstation-deps golang-webdev zsh-plugin-syntax-highlight;
    }
    {
      inherit system hostname username homeDirectory fullName commitEmail windowsUsername;
    };
}
