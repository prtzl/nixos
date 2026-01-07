{
  ...
}:

{
  imports = [ ../../profiles/home ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "prtzl";
      user.email = "matej.blagsic@protonmail.com";
      core = {
        init.defaultBranch = "master";
      };
    };
  };
}
