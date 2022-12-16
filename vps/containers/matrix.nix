{ config, lib, pkgs, ... }:
{
  containers.matrix.config =
    { config, lib, pkgs, ... }:
    let
      fqdn = "${config.networking.hostName}.${config.networking.domain}";
    in
    {
      system.stateVersion = "23.05";

      users.groups.keys = {};

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
        port = 5432;
        # FIXME that SHOULD be reconsidered
        authentication = pkgs.lib.mkOverride 10 ''
          local all all trust
          host all all 127.0.0.1/32 trust
          host all all ::1/128 trust
        '';
        initialScript = "/etc/matrix/synapse-init.sql";
      };

      users.users.postgres.extraGroups = [ config.users.groups.keys.name ];

      services.matrix-synapse = {
        enable = true;
        settings = {
          server_name = config.networking.domain;
          listeners = [
            { port = 8008;
              bind_addresses = [ "::1" ];
              type = "http";
              tls = false;
              x_forwarded = true;
              resources = [{ compress = true; names = [ "federation" "client" ]; }];
            }
          ];
          trusted_key_servers = [
            {
              server_name = "matrix.org";
              verify_keys."ed25519:auto" = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
            }
          ];
          enable_registration = true;
          enable_registration_captcha = true;
          public_baseurl = "https://" + fqdn;
          max_upload_size = "50M";
        };
        extraConfigFiles = [ "/etc/matrix/secrets" ];
      };

      users.users.matrix-synapse.extraGroups = [ config.users.groups.keys.name ];

      systemd.services.matrix-synapse = {
        serviceConfig.SupplementaryGroups = [ config.users.groups.keys.name ];
      };
    };
}
