{ pkgs, ... }:
# vim: ts=2 sts=2 sw=2 et

{
  programs.starship = {
    enable = true;

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
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      git_branch = {
        # format = "on [$symbol$branch]($style)..[$remote_name/$remote_branch]($style)";
        always_show_remote = true;
      };

      nodejs = {
        # disabled = true;
        # symbol = "JS ";
      };

      terraform = {
        format = "via [$symbolv$version/$workspace]($style) ";
      };

      status = {
        disabled = false;
      };
    };
  };
}
