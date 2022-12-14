{ config, pkgs, ... }:
let
  repos = import ./repos-packages.nix { inherit pkgs repos-dir; };
  repos-dir = "/home/git";
  pubKey = builtins.readFile ../.secrets/pubkeys/sum;
in
{
  imports = [
    ./sops.nix
    ./containers
    ./network.nix
    ./git-server.nix
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      allowed-users = [ "*" ];
      trusted-users = [ "root" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  programs.git.enable = true;

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

  users.users.root.openssh.authorizedKeys.keys = [ pubKey ];  # TODO change this after debug

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
    permitRootLogin = "yes"; # TODO change this after debug
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

  system.stateVersion = "23.05";
}
