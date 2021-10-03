{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  easy-hls-src = pkgs.fetchFromGitHub {
    owner  = "jkachmar";
    repo   = "easy-hls-nix";
    rev    = "ecb85ab6ba0aab0531fff32786dfc51feea19370";
    sha256 = "14v0jx8ik40vpkcq1af1b3377rhkh95f4v2cl83bbzpna9aq6hn2";
  };
  easy-hls = pkgs.callPackage easy-hls-src { ghcVersions = [ "9.0.2" ]; };

  f = { mkDerivation, base, containers, lib, X11, xmonad
      , xmonad-contrib
      }:
      mkDerivation {
        pname = "config";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [
          base containers X11 xmonad xmonad-contrib
        ];
        license = "unknown";
        hydraPlatforms = lib.platforms.none;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in
pkgs.haskellPackages.shellFor {
  buildInputs = with pkgs; with haskellPackages; [ implicit-hie cabal-install easy-hls ];
  packages = hp: [ drv ];
}
