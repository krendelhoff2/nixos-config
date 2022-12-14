{ config, lib, pkgs, ... }:
{
  #deployment.keys.secrets.yaml.text = "shhh this is a secret"; think about it
  sops = {
    defaultSopsFile = ../.secrets/secrets.yaml; # cause it gets into /nix/store
    age = {
      # This will automatically import SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # This is using an age key that is expected to already be in the filesystem
      keyFile = "/var/lib/sops-nix/key.txt";
      # This will generate a new key if the key specified above does not exist
      generateKey = true;
    };
    # This is the actual specification of the secrets.
    secrets = {
      "matrix/secrets" = {
        mode = "0440";
        group = config.users.groups.keys.name;
        restartUnits = [ "container@matrix.service" ];
      };
      "matrix/synapse-init.sql" = { mode = "0440"; group = config.users.groups.keys.name; };
      "vault/vault.hcl" = {
        mode = "0440";
        group = config.users.groups.keys.name;
        restartUnits = [ "container@vault.service" ];
      };
      "vault/vault-init.sql" = { mode = "0440"; group = config.users.groups.keys.name; };
    };
  };
  users.groups.keys = {};
}
