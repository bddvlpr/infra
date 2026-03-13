{ pkgs, config, ... }:
{
  sops.secrets."forgejo/runner-token" = { };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.rena = {
      enable = true;
      name = "rena";
      url = "https://git.avali.network";
      tokenFile = config.sops.secrets."forgejo/runner-token".path;
      labels = [
        "ubuntu-latest:docker://catthehacker/ubuntu:act-latest"
        "ubuntu-24.04:docker://catthehacker/ubuntu:act-24.04"
        "ubuntu-22.04:docker://catthehacker/ubuntu:act-22.04"
        "ubuntu-20.04:docker://catthehacker/ubuntu:act-20.04"
      ];
    };
  };

  systemd.services.gitea-runner-rena = {
    after = [ "forgejo.service" ];
    requires = [ "forgejo.service" ];
  };
}
