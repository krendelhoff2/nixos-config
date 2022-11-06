{ pkgs, lib, doomdir ? ./doom.d, ... }:
pkgs.stdenv.mkDerivation {
  name = "savely-emacs-config";
  src = lib.sourceByRegex doomdir [ "config.el" "init.el" "packages.el" ];
  dontUnpack = true;
  installPhase = ''
    cp $src/* .
    install -D -t $out *.el
  '';
}
