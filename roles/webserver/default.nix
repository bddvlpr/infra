{ lib, pkgs, ... }:
let
  ipsFromList = lib.concatMapStringsSep "\n" (ip: "set_real_ip_from ${ip};");
  fileToList = file: lib.splitString "\n" (builtins.readFile file);

  cloudflareIpv4Addresses = fileToList (
    pkgs.fetchurl {
      url = "https://www.cloudflare.com/ips-v4";
      hash = "sha256-8Cxtg7wBqwroV3Fg4DbXAMdFU1m84FTfiE5dfZ5Onns=";
    }
  );
  cloudflareIpv6Addresses = fileToList (
    pkgs.fetchurl {
      url = "https://www.cloudflare.com/ips-v6";
      hash = "sha256-np054+g7rQDE3sr9U8Y/piAp89ldto3pN9K+KCNMoKk=";
    }
  );
in
{
  imports = [ ./anubis.nix ];

  services.nginx = {
    enable = true;

    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    commonHttpConfig = ''
      ${ipsFromList cloudflareIpv4Addresses}
      ${ipsFromList cloudflareIpv6Addresses}
      real_ip_header CF-Connecting-IP;
    '';
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@bddvlpr.com";
  };
}
