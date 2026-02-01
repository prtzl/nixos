{
  inputs,
  lib,
  ...
}:

{
  programs.difftastic.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      core.init.defaultBranch = lib.mkDefault "master";
      log.date = lib.mkDefault "iso";
      # idea is that dir is owned by root but
      # maintainers are in group that has access
      # Git doesn't like this, so I'm placing this here
      safe.directory = "/etc/nixos";
    };
  };

  programs.lazygit = {
    enable = true;
    # get the same lazygit config that I do in my nvimnix (since it needs to be portable, it's defined there)
    settings = inputs.nvimnix.lazygit-settings or { };
  };
}
