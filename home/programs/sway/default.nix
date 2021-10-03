{ config, lib, pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    extraConfig = ''
      set $menu bemenu-run

      # screenshots
      bindsym $mod+c exec grim  -g "$(slurp)" /tmp/$(date +'%H:%M:%S.png')


      exec dbus-sway-environment
      exec configure-gtk
    '';
  };
}
