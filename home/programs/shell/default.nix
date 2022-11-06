{ pkgs, lib, ...}:
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
    };
    interactiveShellInit = commonInit + ''
      set fish_color_command a020f0
      set -U fish_greeting ""
      bass source "$GUIX_PROFILE/etc/profile"
      function fish_user_key_bindings
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert
        set fish_cursor_default block
        set fish_cursor_insert line
        set fish_cursor_replace_one underscore
      end
      function rebuild
        set target $argv[1]
        set -q target || set target savely-machine
        deploy "$HOME/.dotfiles#$target"
      end
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
