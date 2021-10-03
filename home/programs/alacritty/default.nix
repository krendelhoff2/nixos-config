{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 13;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        builtin_box_drawing = true;
      };
      colors = {
        background = "#040404";
        foreground = "#c5c8c6";
      };
      selection.save_to_clipboard = true;
      bell = {
        animation = "EaseOutExpo";
        duration = 5;
        color = "#ffffff";
      };
      shell.program = "${pkgs.fish}/bin/fish";
      key_bindings = [
        { key = "Space"; mods = "Control"; action = "ToggleViMode"; }
      ];
      window = {
        decorations = "full";
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };
}
