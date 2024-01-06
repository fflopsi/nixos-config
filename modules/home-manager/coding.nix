{ pkgs, ... }:

{
  # Packages to be installed
  home.packages = with pkgs; [
    android-studio
    jetbrains.idea-community
    jetbrains.pycharm-community
  ];

  # Git
  programs.git = {
    enable = true;
    userName  = "fflopsi";
    userEmail = "florian.l.frauenfelder@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "libsecret";
    };
  };
}
