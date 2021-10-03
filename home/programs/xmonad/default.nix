{ pkgs, ...}:
{
  xsession = {
    enable = true;

    # let being very generic in environments
    initExtra = ''
      autorandr -l savely-profile
      nitrogen --set-zoom-fill "$HOME/.dotfiles/wallpaper2.jpg"
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
      ];
      config = ./xmonad.hs;
    };
  };
}
