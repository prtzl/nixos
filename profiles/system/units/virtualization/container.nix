{
  pkgs,
  pillow,
  ...
}:

let
  enablePodman = pillow.settings.container.podman.enable or false;
  enableDocker = pillow.settings.container.docker.enable or false;
  enableContainer = enableDocker || enablePodman;
in
{
  virtualisation = {
    containers.enable = enableContainer;
    podman = {
      enable = enablePodman;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    docker.enable = enableDocker;
  };

  environment.systemPackages =
    with pkgs;
    lib.optionals enableContainer [ dive ]
    ++ lib.optionals enablePodman [
      podman-compose # compose
      podman-tui # status of containers in the terminal
    ]
    ++ lib.optionals enableDocker [ docker-compose ];
}
