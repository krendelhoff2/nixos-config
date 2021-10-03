{ pkgs, ... }:
{
  services.xidlehook = {
    enable = true;
    not-when-fullscreen = true;
    not-when-audio = true;
    timers = [{
      delay = 120;
      command = "${pkgs.writeShellScript "locker" ''
        ${pkgs.xorg.xkbcomp}/bin/setxkbmap us -variant colemak_dh
        ${pkgs.betterlockscreen}/bin/betterlockscreen --lock
      ''}";
    }];
  };
}
