{ pkgs, ... }@args:

{ fullName, commitEmail, hostname, homeDirectory ? builtins.getEnv "HOME", username ? builtins.baseNameOf homeDirectory, windowsUsername ? "", extraSpecialArgs ? {}, ... }:

{
  isWSL = windowsUsername != "";
  windowsHome = pkgs.lib.optionalString (windowsUsername != "") "/mnt/c/Users/${windowsUsername}";
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (pkgs) system;

  inherit homeDirectory username windowsUsername fullName commitEmail hostname;
} // (
  # Include additional packages from flakes (and other args passed at
  # compile time)
  pkgs.lib.filterAttrs (n: v: n != "pkgs") args
) // extraSpecialArgs
