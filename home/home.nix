{ config, pkgs, ... }:
with pkgs; with (import ./bindings.nix pkgs);
rec {
  programs.home-manager.enable = true;

  imports = [
    ./programs/xmonad
    ./programs/rofi
    ./programs/git
    ./programs/gpg
    ./programs/direnv
    ./programs/kitty
    ./programs/shell
    ./programs/starship
    ./services/xidlehook
    ./services/dunst
    ./services/picom
    ./services/udiskie
    ./services/redshift
    ./services/gpg-agent
    ./services/sound-max
  ];

  nixpkgs.config.allowUnfree = true;

  home = rec {
    username = "savely";

    homeDirectory = "/home/${username}";

    pointerCursor = {
      package = pkgs.numix-cursor-theme;
      name = "Numix-Cursor";
      size = 5;
      gtk.enable = true;
      x11.enable = true;
    };

    packages = utilities
            ++ desktop
            ++ media
            ++ internet
            ++ pswd
            ++ nixTools
            ++ messagers
            ++ sharedProgrammingTools
            ++ virt
            ++ crypt
            ++ games
            ;

    keyboard = {
      layout = "us,ru";
      variant = "colemak_dh,";
      options = [ "ctrl:nocaps" ];
    };

    stateVersion = "22.11";

    sessionVariables = {
      HEADER42_LOGIN = "dlaptov";
    };
  };

  xdg.configFile."nixpkgs/config.nix".source = ./config.nix;

  fonts.fontconfig.enable = true;

  # опытным путем проверено что тут все работает кроме
  # cursorTheme, который выставлен выше.
  gtk = {
    enable = true;
    theme = {
      name = "SolArc-Dark";
      package = pkgs.solarc-gtk-theme;
    };
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerdfonts;
      size = null;
    };
  };

  programs.tmux.enable = true;
  programs.htop.enable = true;
  programs.bat.enable = true;
  programs.fzf.enable = true;

  programs.autorandr = {
    enable = true;
    profiles.savely-profile = {
      fingerprint.DP-0 = builtins.readFile ../.secrets/DP-0;
      config.DP-0 = {
        enable = true;
        primary = true;
        crtc = 0;
        mode = "2560x1440";
        rate = "165.00";
        position = "";
        dpi = null;
        scale = null;
        transform = null;
        gamma = "";
        rotate = null;
      };
      hooks = {};
    };
  };
}
