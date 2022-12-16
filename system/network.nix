{ pkgs, ...}:
{
  networking = {

    hostName = "savely-machine";

    useDHCP = false;

    hosts = {
      "139.162.148.166" = [ "savely.io" ];
    };

    nameservers = [ "1.1.1.1" ];

    interfaces = {
      enp42s0.useDHCP = true;
      enp7s0.useDHCP = true;
    };

    wireless = {
      enable = false;
      iwd.enable = true;
    };

    firewall = {
      allowedUDPPorts = [ 7717 53222 ];
    };

    wg-quick.interfaces = {
      savely-wg = {
        address = [ "10.0.0.2/24" ];
        listenPort = 7717;
        privateKeyFile = "/etc/wireguard/private";
        peers = [{
          publicKey = "TF3WxPB2js09KqEFha2Ez7cRAUzj2K/9eFpzb0JIQGs=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "139.162.148.166:7717";
          persistentKeepalive = 25;
        }];
      };
      #serokell-wg = {
      #  address = [ "10.99.0.129" ];
      #  listenPort = 53222;
      #  privateKeyFile = "/etc/wireguard/private2";
      #  peers = [{
      #    publicKey = "0mC/xGiV9rl4l4NAPx/GhVvzF9l+CNK+uBEpAJLe8Qc=";
      #    allowedIPs = [ "0.0.0.0/0" ];
      #    endpoint = "vpn.serokell.net:53222";
      #    persistentKeepalive = 25;
      #  }];
      #};
    };#
  };
}
