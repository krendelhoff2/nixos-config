# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  pubKey = builtins.readFile ../.secrets/pubkeys/pub;
in
{
  imports = [
    ./xmonad.nix
    ./network.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.11";

  environment.systemPackages = with pkgs; [
  ];

  programs.git.enable = true;

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
        "https://hydra.iohk.io"
        "s3://serokell-private-nix-cache?endpoint=s3.us-west-000.backblazeb2.com&profile=backblaze-nix-cache"
        "s3://serokell-private-cache?endpoint=s3.eu-central-1.wasabisys.com&profile=wasabi-nix-cache"
      ];
    };

    gc = {
      automatic = false; # shit from the ass
      dates = "daily";
    };
  };

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
    openssh.authorizedKeys.keys = [ pubKey ];
  };

  services.flatpak.enable = true;

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

  hardware.ledger.enable = true;

  location.latitude = 41.00824;
  location.longitude = 28.978336;

  virtualisation = {
    docker.enable = true;
    virtualbox = {
      guest = {
        enable = true;
        x11 = false;
      };
      host = {
        enable = true;
        enableExtensionPack = true;
      };
    };
    #vmware = {
    #  guest.enable = true;
    #  host.enable = true;
    #};
    libvirtd.enable = true;
  };

  services.tor.enable = true;

  programs.steam.enable = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  systemd = {
    mounts = [{
      enable = true;
      unitConfig = {
        Description = "Read-only /gnu/store for GNU Guix";
        DefaultDependencies = "no";
        ConditionPathExists = "/gnu/store";
        Before = "guix-daemon.service";
      };
      wantedBy = [ "guix-daemon.service" ];
      where = "/gnu/store";
      what = "/gnu/store";
      type = "none";
      options = "bind,ro";
    }];
    services.guix-daemon = {
      enable = true;
      description = "Build daemon for GNU Guix";
      serviceConfig = {
        ExecStart = "/var/guix/profiles/per-user/root/current-guix/bin/guix-daemon --build-users-group=guixbuild";
        Environment = "'GUIX_LOCPATH=/var/guix/profiles/per-user/root/guix-profile/lib/locale' LC_ALL=en_US.utf8";
        RemainAfterExit = "yes";
        StandardOutput = "journal";
        StandardError = "journal";
        TasksMax = 8192;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
