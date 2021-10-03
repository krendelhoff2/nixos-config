{ config, pkgs, ...}:
{
  networking.nat = { 
    enable = true;
    externalInterface = "eth0";
    internalInterfaces = [ "savely-wg" ];
  };
  networking.firewall = {
    allowedUDPPorts = [ 7717 ];
  };

  networking.wg-quick.interfaces = {
    savely-wg = {
      address = [ "10.0.0.1/24" ];

      listenPort = 7717;

      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i savely-wg -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
      '';

      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i savely-wg -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
      '';

      privateKeyFile = "/etc/wireguard/private";

      peers = [{ 
        publicKey = "PiMqC/sQBtd3gtwA9fZLOP+Oca5kR/aPsdsGirbqeBY=";
        allowedIPs = [ "10.0.0.2/32" ];
      }] ++ [{
        publicKey = "2STaDIl70AXMf16/zxQU7PVnk/64mUgGY4SPuDk8FXU=";
        allowedIPs = [ "10.0.0.3/32" ];
      }] ++ [{
        publicKey = "4bfuBah12o6a4SjFlVBgqyTrgr6bplYvN3t93QFwsiY=";
        allowedIPs = [ "10.0.0.4/32" ];
      }];
    };
  };
}
