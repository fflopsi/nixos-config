{ pkgs, ... }:

{
  # Packages to be installed
  home.packages = with pkgs; [
    android-studio
    jetbrains.idea-community
    jetbrains.pycharm-community
    jetbrains.pycharm-professional
    vscodium
    git-credential-oauth
  ];

  # Git
  programs.git = {
    enable = true;
    userName  = "fflopsi";
    userEmail = "florian.l.frauenfelder@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "oauth";
    };
  };
}
