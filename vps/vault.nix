address: { config, lib, pkgs, ... }:
{
  system.stateVersion = "23.05";

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8200 8201 ];
    };
  };
  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "vault-init.sql" ''
      CREATE ROLE "vault" WITH LOGIN PASSWORD 'vault';
      CREATE DATABASE "vault" WITH OWNER "vault"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
  };

  services.consul.enable = false; # do this later don't suka forget

  services.vault = {
    enable = true;
    package = pkgs.vault-bin;
    address = "${address}:8200";
    storageBackend = "postgresql";
    storageConfig = ''
      connection_url = "postgres://vault:vault@127.0.0.1:5432/vault"
      table = "vault_kv_store"
    '';
    extraConfig = ''
      disable_mlock = true
      ui = true
      api_addr = "http://${address}:8200"
      cluster_addr = "https://${address}:8201"
    '';
  };
  users.users.vault.extraGroups = ["keys"];
}
