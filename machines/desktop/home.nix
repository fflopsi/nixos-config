{ config, osConfig, pkgs, lib, ... }:

{
  imports = let modules = "../../modules/home-manager"; in [
    ./${modules}/home-hyprland.nix
    ./${modules}/gaming.nix
  ];

  # Displays
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-2,2560x1440@59.95,0x0,1"
      "DP-1,2560x1440@279.96,2560x0,1,vrr,2"
    ];
    workspace = (
      builtins.concatLists (builtins.genList (
        x: let ws = builtins.toString (x+1);
        in [ "${ws}, monitor:DP-1, persistent:true" ]
      ) 5)
    )
    ++ (
      builtins.concatLists (builtins.genList (
        x: let ws = builtins.toString (x+6);
        in [ "${ws}, monitor:DP-2, persistent:true" ]
      ) 4)
    );
  };
}
