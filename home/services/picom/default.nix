{ pkgs, ... }:
{
  services.picom = {
    enable = true;
#    experimentalBackends = true;
    settings = {
      fading = true;
      fade-delta = 7;
      fade-in-step = 0.028;
      fade-out-step = 0.03;
      fade-exclude = [];

      shadow = true;
      shadow-offset-x = -15;
      shadow-offset-y = -15;
      shadow-opacity = 0.75;
      shadow-exclude = [];

      active-opacity = 1.0;
      inactive-opacity = 0.9;
      inactive-dim = 0.0;
      opacity-rule = [
        "100:class_g = 'Rofi'"
        "100:class_g = 'TelegramDesktop'"
      ];

      corner-radius = 15;

      wintypes = {
        dock = { shadow = false; };
        dnd = { shadow = false; };
        popup_menu = { opacity = 1.0; };
        dropdown_menu = { opacity = 1.0; };
      };

      backend = "xrender";
      unredir-if-possible = false;
      vsync = true;
    };
  };
}
