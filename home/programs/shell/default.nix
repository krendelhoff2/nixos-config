{ config, pkgs, lib, ...}:
let
  commonInit = ''
    export PATH="$HOME/.cargo/bin:$HOME/.config/guix/current/bin:$PATH"
    export GUIX_PROFILE="$HOME/.guix-profile"
    export EDITOR='emacsclient -t -a ""'
    alias vim="$EDITOR"
  '';
in
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
      ssh = "kitty +kitten ssh";
      vps = "kitty +kitten ssh savely-vps -t";
      mopidy = config.systemd.user.services.mopidy.Service.ExecStart;
    };
    functions = {
      rebuild.body = ''
        set target "$argv[1]"
        test -z "$target"; and set target "savely-machine"
        set path "$HOME/.dotfiles#$target"
        set i 1
        for arg in $argv;
          set i (math $i + 1)
          if [ $arg = "--" ]
             break
          end
        end
        set args $argv[$i..-1]
        if [ "$target" = "savely-machine" ]
            sudo nixos-rebuild switch --flake "$path" $args
        else
            deploy --remote-build "$path" -- $args
        end
      '';
      fish_user_key_bindings.body = ''
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert
        set fish_cursor_default block
        set fish_cursor_insert line
        set fish_cursor_replace_one underscore
      '';
    };
    interactiveShellInit = commonInit + ''
      set fish_color_command a020f0
      set -U fish_greeting ""
      bass source "$GUIX_PROFILE/etc/profile"
      colorscript -r
    '';
    plugins = [];
  };
  programs.zoxide.enable = true;
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    initExtra = commonInit + ''
      source "$GUIX_PROFILE/etc/profile"
      rebuild () {
        deploy "$HOME/.dotfiles#$1"
      }
    '';
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    autocd = true;
    dirHashes = {
      dl = "$HOME/Downloads";
    };
    shellAliases = {
      ls = "exa";
      cat = "bat --style plain";
    };
    envExtra = ''
      PATH="$HOME/.emacs.d/bin:$HOME/.config/guix/current/bin:$PATH"
      GUIX_PROFILE="$HOME/.guix-profile"
    '';
    initExtra = commonInit + ''
      source "$GUIX_PROFILE/etc/profile"
      colorscript -r
      bindkey -e
      bindkey '\e' vi-cmd-mode
      rebuild () {
        deploy "$HOME/.dotfiles#$1"
      }
    '';
    prezto = {
      enable = true;
      editor = {
        dotExpansion = true;
        keymap = "emacs";
      };
    };
  };
}
