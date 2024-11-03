{ pkgs, ... }:

{
imports = [
  ./gnome-dconf.nix
  ./gnome-extensions.nix
  ./office.nix
  ./coding.nix
  ./bash.nix
];

home.username = "flopsi";
home.homeDirectory = "/home/flopsi";

# This value determines the Home Manager release that your
# configuration is compatible with. This helps avoid breakage
# when a new Home Manager release introduces backwards
# incompatible changes.
# You can update Home Manager without changing this value. See
# the Home Manager release notes for a list of state version
# changes in each release.
home.stateVersion = "23.05";

# Let Home Manager install and manage itself.
programs.home-manager.enable = true;

# Packages to be installed
home.packages = with pkgs; [
  terminus-nerdfont papirus-icon-theme adw-gtk3
  gnome-secrets gnome-browser-connector
  gnomeExtensions.quick-settings-tweaker gnomeExtensions.gnome-40-ui-improvements
];

# Add ~/.local/bin to path (for user-specific scripts)
home.sessionPath = [ "$HOME/.local/bin" ];
}
