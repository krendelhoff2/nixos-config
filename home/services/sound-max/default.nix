{ config, lib, pkgs, ... }:
{
  systemd.user.services = {
    sound-max = {
      Unit = {
        Description = "sound-max oneshot script";
        Wants = "sound-max.timer";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.alsa-utils}/bin/amixer sset 'Master' 100%";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
  systemd.user.timers = {
    sound-max = {
      Unit = {
        Description = "sound-max oneshot script launch timer";
        Requires = "sound-max.service";
      };
      Timer = {
        Unit = "sound-max.service";
        OnCalendar = "*:0/1";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
