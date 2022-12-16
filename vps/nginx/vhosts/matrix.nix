{ config, lib, pkgs, ... }:
let
  domain = "krendelhoff.space";
  clientConfig = {
    "m.homeserver".base_url = "https://matrix.${domain}";
    "m.identity_server".base_url = "https://vector.im";
  };
  serverConfig."m.server" = "matrix.${domain}:443";
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in
{
  services.nginx.virtualHosts = {
    "${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
      locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
    };
    "element.${domain}" = {
      enableACME = true;
      forceSSL = true;
      root = pkgs.element-web.override { conf.default_server_config = clientConfig; };
    };
    "matrix.${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."~ ^(/_matrix|/_synapse/client)" = {
        proxyPass = "http://[::1]:8008";
        extraConfig = ''
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Host $host;
          proxy_headers_hash_max_size 1024;
          proxy_headers_hash_bucket_size 128;
          client_max_body_size 50M;
          proxy_http_version 1.1;
        '';
      };
    };
  };
}
