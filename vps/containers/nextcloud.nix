{ config, lib, pkgs, ... }:
let
  address = config.containers.nextcloud.localAddress6;
in
{
  containers.nextcloud.config =
    { config, lib, pkgs, ... }:
    {
      services.nextcloud = {
        enable = true;
        hostName = address;
        config.adminpassFile = "/etc/nextcloud/adminpass";
      };

      users.groups.keys = {};

      users.users.nextcloud.extraGroups = [ config.users.groups.keys.name ];

      system.stateVersion = "23.05";

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 ];
      };
    };
}
