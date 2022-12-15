# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [
    ./graphics.nix
    ./network.nix
    ./hardware-configuration.nix
    ./yubikey.nix
    ./guix.nix
    ../.secrets/sudo-rules.nix
  ];

  system.stateVersion = "22.11";

  environment.systemPackages = with pkgs; [];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = ./colemak_dh_ansi_us.map;
  };

  # alsa-utils like amixer
  sound.enable = true;
  # actual sound server
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  users.users.savely = {
    isNormalUser = true;
    initialHashedPassword = "";
    extraGroups = [ "wheel" "docker" "vboxusers" "libvirtd" ];
  };

  hardware.ledger.enable = true;

  services.flatpak.enable = true;

  programs.git.enable = true;

  programs.steam.enable = true;

  programs.dconf.enable = true;

  programs.seahorse.enable = true;

  programs.thunar.enable = true;

  programs.gnome-disks.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.udisks2.enable = true;

  services.tor.enable = true;

  virtualisation = {
    docker.enable = true;
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
    vmware.host.enable = true;
    libvirtd.enable = true;
  };

  nix = {
    settings = {
      allowed-users = [ "*" ];
      trusted-users = [ "root" ];
      experimental-features = [ "nix-command" "flakes" ];
      accept-flake-config = true;
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "serokell-1:aIojg2Vxgv7MkzPJoftOO/I8HKX622sT+c0fjnZBLj0="
      ];
      substituters = [
        "https://cache.iog.io"
        "s3://serokell-private-nix-cache?endpoint=s3.us-west-000.backblazeb2.com&profile=backblaze-nix-cache"
        "s3://serokell-private-cache?endpoint=s3.eu-central-1.wasabisys.com&profile=wasabi-nix-cache"
      ];
    };

    gc = {
      automatic = false;
      dates = "daily";
    };
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      nerdfonts
      powerline-fonts
      font-awesome
      julia-mono
      material-design-icons
      emacs-all-the-icons-fonts
    ];
  };
}
