{ config, pkgs, ... }: 
let
  repos-dir = "/home/git"; #set up a directory to hold the git repos, this will also be the git users home directory
  pubKey = builtins.readFile ../.secrets/pubkeys/pub;
  serejaKey = builtins.readFile ../.secrets/pubkeys/sereja;
in
{
  services.cron.enable = true;
  #services.cron.systemCronJobs = [ "30 9 * * * root repos-backup" ]; #run repos-backup once a day at 9:30

  nix.gc.automatic = true;

  users.users.git = {
    isNormalUser = true;
    description = "git user";
    createHome = true;
    home = "${repos-dir}";
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [ pubKey serejaKey ];
  };
}
