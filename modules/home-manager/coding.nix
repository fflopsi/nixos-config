{ pkgs, ... }:

{
home.packages = with pkgs; [
  nixd
  github-desktop
  android-studio
  jetbrains.idea-community jetbrains.idea-ultimate
  jetbrains.pycharm-community jetbrains.pycharm-professional
  nodejs_latest
];

programs = {
  gh.enable = true;
  gh-dash.enable = true;
  git-credential-oauth.enable = true;
  gradle.enable = true;
  java.enable = true;
  lazygit.enable = true;

  git = {
    enable = true;
    userName  = "fflopsi";
    userEmail = "florian.l.frauenfelder@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = [ "oauth" "cache --timeout 86400" ];
    };
  };

  vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = [ pkgs.vscode-extensions.bbenoist.nix ];
  };
};
}
