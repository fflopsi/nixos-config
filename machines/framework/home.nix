{ config, osConfig, pkgs, ... }:

{
  imports = let modules = "../../modules/home-manager"; in [
    ./${modules}/home-hyprland.nix
  ];

  # Displays
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1,preferred,auto,1"
      "DP-3,preferred,auto-right,1,mirror,eDP-1" # Mirror external displays via HDMI
    ];
    # Uncomment if not mirroring to get separate workspaces
    #workspace = [
    #  "1, monitor:eDP-1, persistent:true, default:true"
    #  "7, monitor:DP-3, persistent:false, default:true"
    #]
    #++ (
    #  builtins.concatLists (builtins.genList (
    #    x: [ "${builtins.toString (x+2)}, monitor:eDP-1" ]
    #  ) 5)
    #)
    #++ (
    #  builtins.concatLists (builtins.genList (
    #    x: [ "${builtins.toString (x+8)}, monitor:DP-3" ]
    #  ) 2)
    #);
  };
}
