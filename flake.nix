{
  description = "Based flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";
    rust-overlay.url = "github:oxalica/rust-overlay";
    deploy-rs.url = "github:serokell/deploy-rs";
    eww.url = "github:elkowar/eww";
    polymc.url = "github:PolyMC/PolyMC";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = {
    eww,
    self,
    polymc,
    nixpkgs,
    deploy-rs,
    nix-darwin,
    rust-overlay,
    home-manager,
    nix-doom-emacs,
    ...
  }:
  let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ 
        rust-overlay.overlays.default
        polymc.overlay
        deploy-rs.overlay
        (_: _: {
          inherit (eww.packages.${system}) eww;
          inherit (deploy-rs.packages.${system}) deploy-rs;
        })
      ];
      config.allowUnfree = true;
    };
    overlays = import ./overlays.nix { inherit pkgs; };
    system = "x86_64-linux";
  in
  {
     nixosConfigurations = {
       "savely-machine" = nixpkgs.lib.nixosSystem {
         inherit system pkgs;
         specialArgs = {};
         modules = [
           ./system/configuration.nix
           home-manager.nixosModules.home-manager {
             home-manager = {
               useGlobalPkgs = true;
               useUserPackages = true;
               users.savely = nixpkgs.lib.mkMerge [
                 nix-doom-emacs.hmModule
                 (import ./home/programs/emacs/doom-emacs.nix)
                 (import ./home/home.nix)
               ];
               extraSpecialArgs = {
                 inherit overlays;
                 doomdir = ./home/programs/emacs/doom.d;
               };
             };
           }
         ];
       };

       "savely-vps" = nixpkgs.lib.nixosSystem {
         inherit system pkgs;
         specialArgs = {};
         modules = [
           ./vps/configuration.nix
           home-manager.nixosModules.home-manager {
             home-manager = {
               extraSpecialArgs = {
                 inherit overlays;
                 doomdir = ./vps/doom.d;
               };
               users.savely = nixpkgs.lib.mkMerge [
                 nix-doom-emacs.hmModule
                 (import ./home/programs/emacs/doom-emacs.nix)
                 (import ./vps/home.nix)
               ];
             };
           }
         ];
       };
     };

     deploy.nodes = {
       "savely-machine" = {
         hostname = "localhost";
         profiles = {
           system = {
             user = "root";
             sshUser = "savely";
             sshOpts = [ "-t" ];
             sudo = "sudo -S -u";
             magicRollback = false;
             path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."savely-machine";
           };
         };
       };

       "savely-vps" = {
         hostname = "139.162.148.166";
         profiles.system = {
           user = "root";
           sshUser = "savely";
           sshOpts = [ "-t" ];
           sudo = "sudo -S -u";
           magicRollback = false;

           path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."savely-vps";
         };
       };
     };

     # This is highly advised, and will prevent many possible mistakes
     #checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
