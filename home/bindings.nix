{ config, pkgs, ... }:
with pkgs; rec {
  layout-switch = writeShellScriptBin "layout-switch"
    (builtins.readFile ./scripts/layout-switch.sh);

  powermenu = writeShellScriptBin "powermenu"
    (builtins.readFile ./scripts/powermenu.sh);

  launch-bar = writeShellScriptBin "launch-bar"
    (builtins.readFile ./scripts/launch-bar.sh);

  toggle-sidebar = writeShellScriptBin "toggle-sidebar"
    (builtins.readFile ./scripts/toggle-sidebar.sh);

  pswd = [
    xkcdpass
  ];

  nixTools = [
    nix-prefetch-git
    rnix-lsp
    nixfmt
    cabal2nix
    niv
    deploy-rs
  ];

  internet = [
    brave
  ];

  desktop = [
    ranger
    ledger-live-desktop
    xorg.xev
    xfce.xfce4-screenshooter
    xfce.xfce4-clipman-plugin
    wmctrl
    nitrogen
    eww
    layout-switch
    pavucontrol
    toggle-sidebar
    launch-bar
    powermenu
    qbittorrent
    xdg-utils
    feh
    xclip
    maim
    brightnessctl
  ];

  media = [
    vlc
    mpv
    mpc-cli
    playerctl
    ffmpeg-full
  ];

  crypt = [
    age
    sops
    pwgen
    git-crypt
    cryptsetup
    ssh-to-pgp
    ssh-to-age
    yubikey-manager
    yubioath-flutter
    age-plugin-yubikey
    yubikey-manager-qt
  ];

  sharedProgrammingTools = [
    jre # for minecraft

    cmake
    valgrind
    clang
    clang-tools
    pkg-config
    glslang
    gnumake

    maim
    gnuplot
    graphviz
    pandoc

    sqlite

    sbcl

    texlive.combined.scheme-full

    (python3.withPackages (ps: with ps; [
      jupyter
      python-lsp-server
      toggl-cli
      youtube-dl
      epc
      tld
      lxml
      qtpy
      pysocks
    ]))

    shellcheck

    nodejs
  ] ++ (with nodePackages; [
    bash-language-server
    yaml-language-server
    vscode-langservers-extracted
    dockerfile-language-server-nodejs
  ]);

  utilities = [
    dt-shell-color-scripts
    lshw
    ventoy-bin-full
    cool-retro-term
    xautomation
    xdotool
    killall
    wget
    file
    steam-run # has nothing to do with steam
    patchelf
    usbutils
    hddtemp
    lm_sensors
    pass
    fd
    procs
    hexyl
    simplescreenrecorder
    unrar
    unzip
    tree
    neofetch
    sd
    du-dust
    eva
    exa
    ripgrep
    tokei
    tldr
  ];

  virt = [
    vagrant
    packer
  ];

  messagers = [
    slack
    tdesktop
    discord
  ];

  games = [
    lutris
    polymc
    dwarf-fortress
    fortune
  ];
}
