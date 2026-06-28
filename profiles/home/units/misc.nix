{
  config,
  ...
}:

{
  programs.vim = {
    enable = true;
    extraConfig = ''
      set viminfo=%,'1000,<500,s100,h,n~/.local/state/vim/viminfo
    '';
  };
  home.activation.createVimHistoryDir = ''
    mkdir -p ${config.xdg.stateHome}/vim
  '';

  # python: Don't put python dotshit into home
  home.sessionVariables = {
    PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
  };
  home.activation.createPythonHistoryDir = ''
    mkdir -p ${config.xdg.stateHome}/python
  '';
}
