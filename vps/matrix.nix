address: { config, lib, pkgs, ... }:
let
  fqdn = "${config.networking.hostName}.${config.networking.domain}";
in
{
  system.stateVersion = "22.11";

  networking = {
    hostName = "matrix";
    domain = "krendelhoff.space";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8008 ];
    };
  };

  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
  };

  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = config.networking.domain;
      listeners = [
        { port = 8008;
          bind_addresses = [ address ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [ {
            names = [ "client" "federation" ];
            compress = true;
          } ];
        }
      ];
      public_baseurl = "https://" + fqdn;
      max_upload_size = "50M";
      database = {
        name = "psycopg2";
        args.database = "matrix-synapse";
      };
      enable_registration = true;
      enable_registration_captcha = true;
    };
    extraConfigFiles = [ "/etc/matrix/secret" "/etc/matrix/captcha" ];
  };

  #services.mjolnir = {
  #  enable = true;
  #  homeserverUrl = config.services.matrix-synapse.settings.public_baseurl;
  #  pantalaimon = {
  #     enable = true;
  #     username = "mjolnir";
  #     passwordFile = "/run/secrets/mjolnir-password";
  #  };
  #  protectedRooms = [
  #    "https://matrix.to/#/!xxx:domain.tld"
  #  ];
  #  managementRoom = "!yyy:domain.tld";
  #};
}
