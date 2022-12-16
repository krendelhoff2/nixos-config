{ config, lib, pkgs, ... }:
let
  address = config.containers.vault.localAddress;
in
{
  containers.vault.config =
    { config, lib, pkgs, ... }:
    {
      system.stateVersion = "23.05";

      networking = {
        hostName = "vault";
        domain = "krendelhoff.space";
        firewall = {
          enable = true;
          allowedTCPPorts = [ 8200 ];
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
        initialScript = "/etc/vault/vault-init.sql";
      };

      users.users.postgres.extraGroups = [ "keys" ];

      services.consul.enable = false; # do this later don't suka forget

      services.vault = {
        enable = true;
        package = pkgs.vault-bin;
        address = "${address}:8200";
        extraConfig = ''
          disable_mlock = true
          ui = true
          api_addr = "http://${address}:8200"
        '';
        extraSettingsPaths = [ "/etc/vault/vault.hcl" ];
      };
      users.users.vault.extraGroups = [ "keys" ];
    };
}
