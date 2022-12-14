{ config, lib, pkgs, ... }:
let
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
  domain = config.networking.domain;
in
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "dmitry.laptov@serokell.io";
      dnsProvider = "linode";
    };
  };

  services.gitolite = {
    enable = true;
    extraGitoliteRc = ''$PROJECTS_LIST = $ENV{HOME} . "/projects.list";'';
    adminPubkey = builtins.readFile ../id_rsa.pub;
  };

  services.gitweb.extraConfig = ''
    $projectroot = "${config.services.gitolite.dataDir}/repositories";
    $projects_list = "${config.services.gitolite.dataDir}/projects.list";
  '';

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    gitweb = {
      enable = true;
      inherit (config.services.gitolite) group;
      location = "";
      virtualHost = "gitweb.${domain}";
    };
    virtualHosts = {
      "${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
      "${config.services.nginx.gitweb.virtualHost}" = {
        enableACME = true;
        forceSSL = true;
      };
      "element.${domain}" = {
        enableACME = true;
        forceSSL = true;
        root = pkgs.element-web.override { conf.default_server_config = clientConfig; };
      };
      "matrix.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/".extraConfig = ''
            return 404;
          '';
          "~ ^(/_matrix|/_synapse/client)" = {
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
      "vault.${domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://${config.containers.vault.localAddress}:8200";
      };
    };
  };
}
