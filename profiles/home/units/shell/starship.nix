{
  pkgs,
  ...
}:

{
  programs.starship = {
    enable = true;
    package = pkgs.pkgs-unstable.starship;
    enableZshIntegration = true;
    settings = {
      command_timeout = 50;
      add_newline = false;

      format = "$username$hostname$directory \${custom.shlvl-tmux}$git_branch$git_status$nix_shell$fill $cmd_duration$line_break$jobs$character";

      fill = {
        symbol = " ";
      };

      character = {
        error_symbol = "[»](bold red)";
        success_symbol = "[»](bold green)";
        vicmd_symbol = "[«](bold blue)";
      };

      cmd_duration = {
        min_time = 1000;
        format = "[$duration]($style)";
      };

      directory = {
        before_repo_root_style = "bold blue";
        format = "[$path]($style)[$read_only]($read_only_style)";
        repo_root_format = "[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style)";
        repo_root_style = "bold cyan";
        style = "bold cyan";
        truncate_to_repo = true;
        truncation_length = 8;
        truncation_symbol = "../";
      };

      git_branch = {
        always_show_remote = false;
        format = "[$symbol $branch(󰹴$remote_name/$remote_branch)]($style)";
        style = "bold purple";
        symbol = "󰘬";
      };

      git_status = {
        ahead = "⇡($count)";
        behind = "⇣($count)";
        conflicted = "[](bold red)";
        deleted = "[](bold red)";
        diverged = "⇕⇡($ahead_count)⇣($behind_count)";
        format = "[\\[[$ahead_behind](bold green)[$all_status]($style)\\]]($style)";
        modified = "[󰷈](bold yellow)";
        renamed = "[](bold cyan)";
        staged = "[+](bold green)";
        stashed = "[󰆧](bold purple)";
        style = "bold purple";
        untracked = "[](bold white)";
        up_to_date = "[✓](bold purple)";
      };

      hostname = {
        disabled = false;
        format = "[@$hostname $ssh_symbol]($style)";
        ssh_only = true;
        style = "bold green";
      };

      nix_shell = {
        format = "[$symbol $name \($state\)]($style)";
        style = "bold blue";
        symbol = "";
      };

      username = {
        disabled = false;
        format = "[$user]($style)";
        show_always = false;
        style_root = "bold red";
        style_user = "bold yellow";
      };

      custom.shlvl-tmux = {
        when = "ISTM=0; [ -n \"$TMUX\" ] && ISTM=1; d=$((SHLVL - 2 - ISTM)); [ $d -gt 0 ]";
        command = ''ISTM=0; [ -n "$TMUX" ] && ISTM=1; d=$((SHLVL - 2 - ISTM)); [ $d -gt 0 ] && printf '↕ %d \u200B' "$d";'';
        format = "[$output]($style)";
        style = "yellow";
      };
    };
  };
}
