{ config, lib, pkgs, ... }:
let
  readOnly = { mode = "0440"; group = config.users.groups.keys.name; };
  restart = unit: { restartUnits = [ unit ]; };
in
{
  sops = {
    defaultSopsFile = ../.secrets/secrets.yaml;
    age = {
      # This will automatically import SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # This is using an age key that is expected to already be in the filesystem
      keyFile = "/var/lib/sops-nix/key.txt";
      # This will generate a new key if the key specified above does not exist
      generateKey = false;
    };
    # This is the actual specification of the secrets.
    secrets = {
      "matrix/secrets" = readOnly // restart "container@matrix.service";
      "vault/vault.hcl" = readOnly // restart "container@vault.service";
      "nextcloud/adminpass" = readOnly // restart "container@nextcloud.service";
    };
  };
  users.groups.keys = {};
}
