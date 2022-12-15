{
  programs.git = {
    enable = true;
    extraConfig = {
      rebase.autosquash = false;
      user = {
        signingkey = "0xC6420F128F9E77AF";
        name = "Savely Krendelhoff";
        email = "alicecandyom@proton.me";
      };
      commit.gpgsign = true;
    };
  };
}
