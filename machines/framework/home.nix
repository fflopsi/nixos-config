{ config, osConfig, pkgs, ... }:

{
  imports = let modules = "../../modules/home-manager"; in [
    ./${modules}/home-hyprland.nix
  ];

  # Displays
  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1,preferred,auto,1"
  ];
}
