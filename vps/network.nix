{ config, lib, pkgs, ... }:
{
  imports = [
    ./nginx
    ./vpn.nix
  ];

  networking = {
    usePredictableInterfaceNames = false;
    useNetworkd = true;
    hostName = "savely-vps";
    domain = "krendelhoff.space";
    nameservers = [
      "139.162.130.5"
      "139.162.131.5"
      "139.162.132.5"
      "139.162.133.5"
      "139.162.134.5"
      "139.162.135.5"
      "139.162.136.5"
      "139.162.137.5"
      "139.162.138.5"
      "139.162.139.5"
      "2a01:7e01::5"
      "2a01:7e01::9"
      "2a01:7e01::7"
      "2a01:7e01::c"
      "2a01:7e01::2"
      "2a01:7e01::4"
      "2a01:7e01::3"
      "2a01:7e01::6"
      "2a01:7e01::b"
      "2a01:7e01::8"
    ];
    useDHCP = false;
    interfaces.eth0 = {
      useDHCP = true;
      ipv4.addresses = [{ address = "139.162.148.166"; prefixLength = 24; }];
      ipv6.addresses = [{ address = "2a01:7e01::f03c:93ff:fe38:3ee1"; prefixLength = 64; }];
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 ];
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
