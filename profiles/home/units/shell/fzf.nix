{ ... }:

{
  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    fileWidget.options = [
      "--walker-skip .git,node_modules,target"
      "--preview 'bat -n --color=always {}'"
      "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
    ];
    changeDirWidget.options = [
      "--walker-skip .git,node_modules,target"
      "--preview 'tree -C {}'"
    ];
    historyWidget.options = [
      "--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
      "--color header:italic"
      "--header 'Press CTRL-Y to copy command into clipboard'"
    ];
  };
}
