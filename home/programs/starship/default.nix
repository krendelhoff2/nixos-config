{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;

    settings = {
      add_newline = false;

      character = {
        success_symbol = "[λ❯](bold green)";
        error_symbol = "[μ❮](bold red)";
      };

      nix_shell.symbol = "  ";
      python.symbol = " ";
    };
  };
}
