{ config, lib, pkgs, ... }:
let
  domain = "krendelhoff.space";
in
{
  imports = [
    ./vhosts/gitweb.nix
    ./vhosts/matrix.nix
    ./vhosts/vault.nix
  ];

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "alicecandyom@proton.me";
      dnsProvider = "linode";
    };
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };
}
