pkgs:

self: super: {
  magit-delta = super.magit-delta.overrideAttrs (esuper: {
    buildInputs = esuper.buildInputs ++ [ pkgs.git ];
  });
}
