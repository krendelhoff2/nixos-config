{ config, lib, pkgs, ... }:
let
  domain = "krendelhoff.space";
in
{
  services.gitolite = {
    enable = true;
    extraGitoliteRc = ''$PROJECTS_LIST = $ENV{HOME} . "/projects.list";'';
    adminPubkey = builtins.readFile ../../../.secrets/pubkeys/sum;
  };

  services.gitweb.extraConfig = ''
    $projectroot = "${config.services.gitolite.dataDir}/repositories";
    $projects_list = "${config.services.gitolite.dataDir}/projects.list";
  '';

  services.nginx.gitweb = {
    enable = true;
    inherit (config.services.gitolite) group;
    location = "/";
    virtualHost = "gitweb.${domain}";
  };
}
