{ pkgs ? import <nixpkgs> {}, repos-dir ? "/home/git" }:
let
    stdenv = pkgs.stdenv;
    sh = pkgs.sh;
    coreutils = pkgs.coreutils;
in {
    repos-backup = stdenv.mkDerivation rec {
        name = "repos-backup";
        builder = "${sh}/bin/sh";
        args = [ ./shell-script-builder.sh  ];
        src = ./repos-backup.sh;
        buildInputs = [ coreutils ];
        system = builtins.currentSystem;
    };

    repos-create = stdenv.mkDerivation rec {
        name = "repos-create";
        builder = "${sh}/bin/sh";
        args = [ ./shell-script-builder.sh  ];
        src = ./repos-create.sh;
        buildInputs = [ coreutils ];
        system = builtins.currentSystem;
    }; 

    repos-delete = stdenv.mkDerivation rec {
        name = "repos-delete";
        builder = "${sh}/bin/sh";
        args = [ ./shell-script-builder.sh  ];
        src = ./repos-delete.sh;
        buildInputs = [ coreutils ];
        system = builtins.currentSystem;
    }; 

    repos-list = stdenv.mkDerivation rec {
        name = "repos-list";
        builder = "${sh}/bin/sh";
        args = [ ./shell-string-script-builder.sh  ];
        src = ''
                #!/bin/sh
                . repos-setenvvars
                ls -d $reposDir/*.git | xargs -n1 basename
        '';
        buildInputs = [ coreutils ];
        system = builtins.currentSystem;
    };

    repos-setenvvars = stdenv.mkDerivation rec {
        name = "repos-setenvvars";
        builder = "${sh}/bin/sh";
        args = [ ./shell-string-script-builder.sh  ];
        src = ''
                #!/bin/sh
                # set environment variables for use in repos scripts
                reposDir="${repos-dir}" #directory containing the git repos
                reposBackupDir=$reposDir/repobackups #directory containing the git repos backups
        '';
        buildInputs = [ coreutils ];
        system = builtins.currentSystem;
    };
}
