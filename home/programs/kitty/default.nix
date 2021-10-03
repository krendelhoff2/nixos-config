{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "PragmataPro Mono Liga";
      font_size = 20;
      window_padding_width = 5;
      shell = "${pkgs.fish}/bin/fish";
      copy_on_select = "yes";
      background = "#040404";
      foreground = "#c5c8c6";
    };
  };
}
