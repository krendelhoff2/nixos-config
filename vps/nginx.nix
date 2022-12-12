{ config, lib, pkgs, ... }:
let
  matrix-fqdn = "${config.containers.matrix.config.networking.hostName}.${config.containers.matrix.config.networking.domain}";
  clientConfig = {
    "m.homeserver".base_url = "https://${matrix-fqdn}";
    "m.identity_server".base_url = "https://vector.im";
  };
  serverConfig."m.server" = "${matrix-fqdn}:443";
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "dmitry.laptov@serokell.io";
      dnsProvider = "linode";
    };
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "${config.containers.matrix.config.networking.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
      "element.${config.containers.matrix.config.networking.domain}" = {
        enableACME = true;
        forceSSL = true;
        root = pkgs.element-web.override {
          conf = {
            default_server_config = clientConfig; # see `clientConfig` from the snippet above.
          };
        };
      };
      "${matrix-fqdn}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/".extraConfig = ''
            return 404;
          '';

          "/_matrix" = {
            proxyPass = "http://${config.containers.matrix.localAddress}:8008";
            extraConfig = ''
              client_max_body_size 50M;
              proxy_set_header X-Forwarded-For $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
            '';
          };
          "/_synapse/client" = {
            proxyPass = "http://${config.containers.matrix.localAddress}:8008";
            extraConfig = ''
              client_max_body_size 50M;
              proxy_set_header X-Forwarded-For $remote_addr;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Host $host;
            '';
          };
        };
      };
    };
  };
}
