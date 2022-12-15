{ pkgs, ... }:
let
  guide = pkgs.stdenv.mkDerivation {
    name = "yubikey-guide-2022-08-21.html";
    src = pkgs.fetchFromGitHub {
      owner = "drduh";
      repo = "YubiKey-Guide";
      rev = "5eeae2be7e988871c8db8a54f4ae7f393c9317ae";
      sha256 = "sha256-QuTBK2FpAXiF2IPoD4CeQ1/UZZ8KwAJ2H8Pl668iMfY=";
    };
    buildInputs = [ pkgs.pandoc ];
    installPhase = "pandoc --highlight-style pygments -s --toc README.md -o $out";
  };
in {
  environment.interactiveShellInit = ''
    export GNUPGHOME=/run/user/$(id -u)/gnupghome
    if [ ! -d $GNUPGHOME ]; then
      mkdir $GNUPGHOME
    fi
    cp ${pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/drduh/config/75ec3f35c6977722d4dba17732d526f704f256ff/gpg.conf";
      sha256 = "sha256-LK29P4+ZAvy9ObNGDNBGP/8+MIUY3/Uo4eJtXhwMoE0=";
    }} "$GNUPGHOME/gpg.conf"
    echo "pinentry-program ${pkgs.pinentry-curses}" > $GNUPGHOME/gpg-agent.conf
    echo "\$GNUPGHOME has been set up for you. Generated keys will be in $GNUPGHOME."
  '';

  environment.systemPackages = with pkgs; [
    yubikey-personalization
    service-wrapper
    srm
    cryptsetup
    pwgen
    rng-tools
    midori
    paperkey
    pinentry-curses
    ctmg
  ];

  services.udev.packages = with pkgs; [ yubikey-personalization ];
  services.pcscd.enable = true;

  # make sure we are air-gapped
  networking = {
    wireless.enable = false;
    dhcpcd.enable = false;
  };

  services.getty.helpLine = "The 'root' account has an empty password.";

  security.sudo.wheelNeedsPassword = false;
  users.users.yubikey = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = "/run/current-system/sw/bin/bash";
  };

  services.atd.enable = true;

  services.infnoise = {
    enable = true;
    fillDevRandom = true;
  };

  system.stateVersion = "23.05";

  services.xserver = {
    enable = true;
    layout = "us,ru";
    xkbVariant = "colemak_dh,";
    xkbOptions = "ctrl:nocaps";

    displayManager = {
      autoLogin = {
        enable = true;
        user = "yubikey";
      };
      defaultSession = "xfce";
      sessionCommands = ''
        ${pkgs.midori}/bin/midori ${guide} &
        ${pkgs.xfce.xfce4-terminal}/bin/xfce4-terminal &
      '';
    };

    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };
}
