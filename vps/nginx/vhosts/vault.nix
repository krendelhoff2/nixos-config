{ config, lib, pkgs, ... }:
let
  domain = "krendelhoff.space";
in
{
  services.nginx.virtualHosts = {
    "vault.${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://${config.containers.vault.localAddress}:8200";
    };
  };
}
