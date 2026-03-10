{ config, ... }:
{
  services.anubis.defaultOptions = {
    settings = {
      WEBMASTER_EMAIL = "contact@bddvlpr.com";
      SERVE_ROBOTS_TXT = true;
      OG_PASSTHROUGH = true;
    };
  };

  users.users.nginx.extraGroups = builtins.attrValues (
    builtins.mapAttrs (_: instance: instance.group) config.services.anubis.instances
  );
}
