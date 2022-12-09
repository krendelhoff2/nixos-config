{ config, pkgs, ... }:
{
  programs.ncmpcpp = {
    enable = true;
    mpdMusicDir = "/home/${config.home.username}/music";
    bindings = [
      { key = "j"; command = "scroll_down"; }
      { key = "k"; command = "scroll_up"; }
      { key = "J"; command = [ "select_item" "scroll_down" ]; }
      { key = "K"; command = [ "select_item" "scroll_up" ]; }
    ];
  };
  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [ mopidy-mpd mopidy-local mopidy-ytmusic ];
    settings = {
      file = {
        media_dirs = [
          "/home/${config.home.username}/music|Music"
          "/home/${config.home.username}/Downloads/Torrent|Library"
        ];
        follow_symlinks = true;
        excluded_file_extensions = [
          ".html"
          ".zip"
          ".jpg"
          ".jpeg"
          ".png"
        ];
      };
      local = {
        enabled = true;
        media_dir = "/home/${config.home.username}/music";
      };
      ytmusic = {
        enable = true;
        auth_json = "/home/${config.home.username}/.config/mopidy/auth.json";
      };
    };
  };
}
