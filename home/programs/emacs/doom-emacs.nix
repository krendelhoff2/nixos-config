{ pkgs, stdenv, lib, overlays, doomdir, ... }:
{
  programs.doom-emacs = rec {
    enable = true;
    emacsPackage = pkgs.emacsNativeComp;
    doomPrivateDir = import ./savely-emacs-config.nix { inherit pkgs lib doomdir; };
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
      (load! "${../../../common-doom-config.el}")
      (load! "${ftheader}/list.el")
      (load! "${ftheader}/string.el")
      (load! "${ftheader}/comments.el")
      (load! "${ftheader}/header.el")
    '';
    emacsPackagesOverlay = overlays.emacs-packages;
  };
  services.emacs.enable = true;
}
