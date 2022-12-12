{ config, pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ls = "exa";
      cat = "bat --style plain";
      wg-stop = "sudo systemctl stop wg-quick-savely-wg.service";
      wg-start = "sudo systemctl start wg-quick-savely-wg.service";
      emacs-restart = "systemctl --user restart emacs.service";
    };
    functions = {
      fish_user_key_bindings.body = ''
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert
        set fish_cursor_default block
        set fish_cursor_insert line
        set fish_cursor_replace_one underscore
      '';
    };
    interactiveShellInit = ''
      set fish_color_command a020f0
      set -U fish_greeting ""
    '';
    plugins = [];
  };
  programs.zoxide.enable = true;

  home = {
    packages = with pkgs;[
      exa
      bat
      matrix-synapse
    ];

    stateVersion = "22.11";
  };
}
