{ config, pkgs, ... }:
let
  repos = import ./repos-packages.nix { inherit pkgs repos-dir; };
  repos-dir = "/home/git";
  pubKey = builtins.readFile ../.secrets/pubkeys/pub;
in
{
  imports = [ 
    ./hardware-configuration.nix
    ./git-server.nix
    ./vpn.nix
  ];

  nix = {
    settings = {
      allowed-users = [ "*" ];
      trusted-users = [ "root" "savely" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  programs.git.enable = true;

  networking = {
    usePredictableInterfaceNames = false;
    hostName = "savely-vps";
    useDHCP = false;
    defaultGateway = "139.162.148.1";
    interfaces.eth0 = {
      useDHCP = true;
      ipv4.addresses = [{
        address = "139.162.148.166";
        prefixLength = 24;
      }];
    };
    enableIPv6 = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 21 25565 ];
      allowedTCPPortRanges = [{
        from = 35000;
        to = 40000;
      }];
    };
  };

  environment = {
    sessionVariables = {
      HEADER42_LOGIN = "dlaptov";
    };
  };

  users.users.savely = {
    isNormalUser = true;
    home = "/home/savely";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ pubKey ];
  };

  environment.systemPackages = with pkgs; with repos; [
    vim
    wget
    sysstat
    repos-backup
    repos-create 
    repos-delete 
    repos-list
    repos-setenvvars 
    jre
    xclip
    ripgrep
    fd
    clang
    clang-tools
  ];

  programs.mtr.enable = true;

  programs.tmux.enable = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  services.vsftpd = {
    enable = true;
    writeEnable = true;
    localUsers = true;
    chrootlocalUser = true;
    allowWriteableChroot = true;
    extraConfig = ''
      pasv_enable=Yes
      pasv_min_port=35000
      pasv_max_port=40000
    '';
    userlist = [ "savely" ];
    userlistEnable = true;
  };

  system.stateVersion = "22.05";
}
