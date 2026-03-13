{ config, pkgs, ... }:
{
  sops.secrets."forgejo/smtp/password" = {
    owner = config.services.forgejo.user;
  };

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    database.type = "postgres";
    lfs.enable = true;

    settings = {
      DEFAULT = {
        APP_NAME = "Avali Network";
        APP_SLOGAN = "Chirp!";
      };

      server = {
        DOMAIN = "git.avali.network";
        ROOT_URL = "https://git.avali.network/";
        PROTOCOL = "http+unix";
      };

      service = {
        REGISTER_EMAIL_CONFIRM = true;
        DISABLE_REGISTRATION = false;
      };

      security = {
        INSTALL_LOCK = true;
      };

      mailer = {
        ENABLED = true;
        PROTOCOL = "smtps";
        SMTP_ADDR = "mail.avali.network";
        SMTP_PORT = 465;
        USER = "noreply@avali.network";
        FROM = "No-reply Avali Network <noreply@avali.network>";
      };

      ui = {
        DEFAULT_THEME = "avali-network";
        THEMES = "avali-network";
      };

      "ui.meta" = {
        AUTHOR = "Birds";
      };
    };

    secrets = {
      mailer = {
        PASSWD = config.sops.secrets."forgejo/smtp/password".path;
      };
    };
  };

  systemd.tmpfiles.rules =
    let
      inherit (config.services.forgejo) customDir;
    in
    [
      "d ${customDir}/public - forgejo forgejo - -"
      "d ${customDir}/public/assets - forgejo forgejo - -"
      "d ${customDir}/public/assets/css - forgejo forgejo - -"
      "L+ ${customDir}/public/assets/css/theme-avali-network.css - - - - ${config.assets.forgejo-theme}"
      "d ${customDir}/public/assets/img - forgejo forgejo - -"
      "L+ ${customDir}/public/assets/img/avatar_default.svg - - - - ${config.assets.illuminate-logo-svg}"
      "L+ ${customDir}/public/assets/img/avatar_default.png - - - - ${config.assets.illuminate-logo-128}"
      "L+ ${customDir}/public/assets/img/logo.svg - - - - ${config.assets.illuminate-logo-svg}"
      "L+ ${customDir}/public/assets/img/logo.png - - - - ${config.assets.illuminate-logo-512}"
      "L+ ${customDir}/public/assets/img/favicon.svg - - - - ${config.assets.illuminate-logo-svg}"
      "L+ ${customDir}/public/assets/img/favicon.png - - - - ${config.assets.illuminate-logo-128}"
      "d ${customDir}/templates - forgejo forgejo - -"
      "L+ ${customDir}/templates/home.tmpl - - - - ${config.assets.forgejo-home}"
    ];

  services.anubis.instances.forgejo.settings = {
    TARGET = "unix://${config.services.forgejo.settings.server.HTTP_ADDR}";
  };

  services.nginx.virtualHosts."git.avali.network" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://unix:${config.services.anubis.instances.forgejo.settings.BIND}";
    };
    extraConfig = ''
      client_max_body_size 512M;
    '';
  };
}
