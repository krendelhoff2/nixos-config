{ config, lib, pkgs, ... }:
{
  containers = {
    matrix = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";
      config = import ./matrix.nix config.containers.matrix.localAddress;
    };
  };
}
