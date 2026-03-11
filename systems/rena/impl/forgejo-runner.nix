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
        "ubuntu-latest:docker://node:25-bookworm"
        "ubuntu-24.04:docker://node:25-bookworm"
        "ubuntu-22.04:docker://node:25-bookworm"
      ];
    };
  };
}
