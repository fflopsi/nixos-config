{ pkgs, ... }:

{
  # Allow auto-upgrading
  # system.autoUpgrade = {
    # enable = true;
    # allowReboot = true;
  # };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    topgrade
    firefox libreoffice
    micro btop tldr gitFull inetutils wget curl sl
    gnome.gnome-tweaks gnome.dconf-editor gnome-menus gnome-extension-manager
    gnomeExtensions.appindicator gnomeExtensions.clipboard-indicator
  ];

  # Enable GSConnect
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Enable flatpak
  services.flatpak.enable = true;

  # Sudo insults
  security.sudo.package = pkgs.sudo.override { withInsults = true; };
}
