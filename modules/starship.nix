{ pkgs, isLinux, isWSL, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  programs.starship = {
    enable = true;
    package = pkgs.starship;

    settings = {
      add_newline = true;

      battery = {
        disabled = true;

        display = [
          {
            threshold = 100;
            style = "green";
          }
          {
            threshold = 50;
            style = "yellow";
          }
          {
            threshold = 27;
            style = "red";
          }
          {
            threshold = 15;
            style = "bold red";
          }
        ];
      } // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
        format = "[Batt:$percentage]($style)";
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      cmd_duration = {
        min_time_to_notify = 500; # ms
      };

      git_branch = {
        # format = "on [$symbol$branch]($style)..[$remote_name/$remote_branch]($style)";
        always_show_remote = true;
      };

      kubernetes.disabled = false;

      nix_shell = {
        impure_msg = "";
      };

      nodejs = {
        # disabled = true;
      } // (pkgs.lib.optionalAttrs (isLinux && !isWSL) {
        symbol = "JS ";
      });

      terraform = {
        format = "via [$symbolv$version/$workspace]($style) ";
      };

      status = {
        disabled = false;
      };
    } // {
      aws.disabled = true;
      azure.disabled = true;
      battery.disabled = true;
      buf.disabled = true;
      c.disabled = true;
      cmake.disabled = true;
      cobol.disabled = true;
      conda.disabled = true;
      container.disabled = true;
      crystal.disabled = true;
      daml.disabled = true;
      dart.disabled = true;
      deno.disabled = true;
      docker_context.disabled = true;
      elixir.disabled = true;
      elm.disabled = true;
      erlang.disabled = true;
      gcloud.disabled = true;
      guix_shell.disabled = true;
      haskell.disabled = true;
      haxe.disabled = true;
      hostname.disabled = true;
      julia.disabled = true;
      kotlin.disabled = true;
      memory_usage.disabled = true;
      meson.disabled = true;
      ocaml.disabled = true;
      openstack.disabled = true;
      os.disabled = true;
      perl.disabled = true;
      php.disabled = true;
      pulumi.disabled = true;
      purescript.disabled = true;
      raku.disabled = true;
      red.disabled = true;
      scala.disabled = true;
      singularity.disabled = true;
      spack.disabled = true;
      sudo.disabled = true;
      swift.disabled = true;
      username.disabled = true;
      vagrant.disabled = true;
      vlang.disabled = true;
      vcsh.disabled = true;
    };
  };

  programs.starship.enableZshIntegration = true;
}
