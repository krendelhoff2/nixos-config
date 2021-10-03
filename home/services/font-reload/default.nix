{ config, lib, pkgs, ... }:
{
  systemd.user.services = {
    font-reload = {
      Unit = {
        Description = "font-reload oneshot script";
        Wants = "font-reload.timer";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.emacsNativeComp}/bin/emacsclient -e '(doom/reload-font)'";
      };
      Install = {
        WantedBy = [ "multi-user.target" ];
      };
    };
  };
  systemd.user.timers = {
    font-reload = {
      Unit = {
        Description = "font-reload oneshot script launch timer";
        Requires = "font-reload.service";
      };
      Timer = {
        Unit = "font-reload.service";
        OnCalendar = "*:0/1";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
