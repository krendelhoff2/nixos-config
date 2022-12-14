{ config, lib, pkgs, ... }:
{
  imports = [
    ./vpn.nix
    ./nginx.nix
    ./containers.nix
  ];

  networking = {
    usePredictableInterfaceNames = false;
    hostName = "savely-vps";
    domain = "krendelhoff.space";
    useDHCP = false;
    nameservers = [
      "ns1.linode.com"
      "ns2.linode.com"
      "ns3.linode.com"
      "ns4.linode.com"
      "ns5.linode.com"
    ];
    interfaces.eth0.useDHCP = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 443 ];
      allowedUDPPorts = [ 7717 ];
      allowedTCPPortRanges = [{
        from = 35000;
        to = 40000;
      }];
    };
    nat = {
      enable = true;
      internalInterfaces = [ "savely-wg" ];
      externalInterface = "eth0";
      enableIPv6 = true;
    };
  };
}
