{ config, lib, pkgs, ... }:
{
  programs.dconf.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.seahorse.enable = true;

  programs.thunar.enable = true;

  programs.gnome-disks.enable = true;

  programs.gamemode.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services = {

    dbus.packages = [ pkgs.dconf ];

    xserver = {
      enable = true;

      layout = "us,ru";
      xkbVariant = "colemak_dh,";
      xkbOptions = "ctrl:nocaps";

      libinput = {
        enable = true;
        mouse.naturalScrolling = true;
        mouse.accelSpeed = "maxSpeed";
        mouse.accelProfile = "adaptive";
      };

      autoRepeatDelay = 180;
      autoRepeatInterval = 20;

      displayManager = {
        defaultSession = "none+xmonad";
 
        autoLogin.user = "savely";

        lightdm = {
          enable = true;
          greeters.gtk.enable = true;
        };
      };
      
      windowManager.xmonad.enable = true;

      videoDrivers = [ "nvidia" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  hardware = {
    enableAllFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      nvidiaSettings = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
