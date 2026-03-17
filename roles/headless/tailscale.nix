{ config, ... }:
{
  sops.secrets."tailscale/auth-key" = { };

  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--login-server=https://tailscale.avali.network" ];
    authKeyFile = config.sops.secrets."tailscale/auth-key".path;
  };
}
