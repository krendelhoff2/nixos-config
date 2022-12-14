{ config, lib, pkgs, ... }:
let
  prefix = "192.168.100";
in
{
  containers = {
    matrix = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "${prefix}.10";
      localAddress = "${prefix}.11";
      config = import ./matrix.nix config.containers.matrix.localAddress;
      bindMounts."/etc/matrix" = {
        hostPath = "/run/secrets/matrix";
        isReadOnly = true;
      };
    };
    vault = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "${prefix}.12";
      localAddress = "${prefix}.13";
      config = import ./vault.nix config.containers.vault.localAddress;
      bindMounts."/etc/vault" = {
        hostPath = "/run/secrets/vault";
        isReadOnly = true;
      };
    };
  };
}
