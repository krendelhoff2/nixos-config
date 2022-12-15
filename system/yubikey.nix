{ config, lib, pkgs, ... }:
{
  services.pcscd.enable = true;

  services.udev.packages = with pkgs; [ yubikey-personalization ];

  services.yubikey-agent.enable = true;

  programs.ssh.startAgent = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam = {
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };

    yubico = {
      enable = true;
      debug = true;
      mode = "challenge-response";
    };
  };
}
