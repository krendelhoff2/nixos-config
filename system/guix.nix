{ config, lib, pkgs, ... }:
{
  systemd = {
    mounts = [{
      enable = true;
      unitConfig = {
        Description = "Read-only /gnu/store for GNU Guix";
        DefaultDependencies = "no";
        ConditionPathExists = "/gnu/store";
        Before = "guix-daemon.service";
      };
      wantedBy = [ "guix-daemon.service" ];
      where = "/gnu/store";
      what = "/gnu/store";
      type = "none";
      options = "bind,ro";
    }];
    services.guix-daemon = {
      enable = true;
      description = "Build daemon for GNU Guix";
      serviceConfig = {
        ExecStart = "/var/guix/profiles/per-user/root/current-guix/bin/guix-daemon --build-users-group=guixbuild";
        Environment = "'GUIX_LOCPATH=/var/guix/profiles/per-user/root/guix-profile/lib/locale' LC_ALL=en_US.utf8";
        RemainAfterExit = "yes";
        StandardOutput = "journal";
        StandardError = "journal";
        TasksMax = 8192;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
