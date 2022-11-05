{ pkgs, lib, overlays, ... }:
{
  home.stateVersion = "22.11";
  programs.doom-emacs = rec {
    enable = true;
    emacsPackage = pkgs.emacsNativeComp;
    doomPrivateDir = pkgs.stdenv.mkDerivation {
      name = "savely-emacs-config";
      src = lib.sourceByRegex ./doom.d [ "config.el" "init.el" "packages.el" ];
      dontUnpack = true;
      installPhase = ''
        cp $src/* .
        install -D -t $out *.el
      '';
    };
    doomPackageDir =
    let
      filteredPath = builtins.path {
        path = doomPrivateDir;
        name = "savely-doom-private-dir-filtered";
        filter = path: type:
          builtins.elem (baseNameOf path) [ "init.el" "packages.el" ];
      };
    in pkgs.linkFarm "savely-doom-packages-dir" [
      {
        name = "init.el";
        path = "${filteredPath}/init.el";
      }
      {
        name = "packages.el";
        path = "${filteredPath}/packages.el";
      }
      {
        name = "config.el";
        path = pkgs.emptyFile;
      }
    ];
    extraConfig =
    let
      ftheader = pkgs.fetchFromGitHub {
        owner = "ggjulio";
        repo = "42header_emacs";
        rev = "master";
        sha256 = "sha256-ozwoGllVItzNmPV0XmArxv3uJD/urYMp5gLEAAqYMVY=";
      };
    in ''
      (load! "${ftheader}/list.el")
      (load! "${ftheader}/string.el")
      (load! "${ftheader}/comments.el")
      (load! "${ftheader}/header.el")
    '';
    emacsPackagesOverlay = overlays.emacs-packages;
  };
  services.emacs.enable = true;
}
