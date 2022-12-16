{ config, lib, pkgs, ... }:
{
  imports = [
    ./vault.nix
    ./matrix.nix
    ./nextcloud.nix
  ];

  programs.extra-container.enable = true;

  containers = {
    matrix = {
      autoStart = true;
      bindMounts."/etc/matrix" = {
        hostPath = "/run/secrets/matrix";
        isReadOnly = true;
      };
    };
    vault = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";
      bindMounts."/etc/vault" = {
        hostPath = "/run/secrets/vault";
        isReadOnly = true;
      };
    };
    #vaultwarden = {
    #  autoStart = true;
    #  bindMounts."/etc/vaultwarden" = {
    #    hostPath = "/run/secrets/vaultwarden";
    #    isReadOnly = true;
    #  };
    #};
    nextcloud = {
      autoStart = true;
      privateNetwork = true;
      hostAddress6 = "fc00::3";
      localAddress6 = "fc00::4";
      bindMounts."/etc/nextcloud" = {
        hostPath = "/run/secrets/nextcloud";
        isReadOnly = true;
      };
    };
  };
}
