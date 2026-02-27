{
  systemd.tmpfiles.rules = [
    "d /srv/storage 0775 root wheel -"
  ];

  services.nginx.virtualHosts."storage.avali.network" = {
    enableACME = true;
    forceSSL = true;

    root = "/srv/storage";

    extraConfig = ''
      autoindex on;
      autoindex_localtime on;
    '';
  };
}
