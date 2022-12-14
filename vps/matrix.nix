address: { config, lib, pkgs, ... }:
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
      enable_registration = true;
      enable_registration_captcha = true;
      public_baseurl = "https://" + fqdn;
      max_upload_size = "50M";
    };
    extraConfigFiles = [ "/etc/matrix/secrets" ];
  };

  systemd.services.matrix-synapse = {
    serviceConfig.SupplementaryGroups = [ config.users.groups.keys.name ];
  };
}
