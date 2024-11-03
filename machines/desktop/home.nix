{ ... }:

{
imports = let modules = "../../modules/home-manager"; in [
  ./${modules}/home-hyprland.nix
  ./${modules}/gaming.nix
];

wayland.windowManager.hyprland.settings = {
  monitor = [
    "DP-2,2560x1440@59.95,0x0,1"
    "DP-1,2560x1440@279.96,2560x0,1,vrr,2"
  ];
  workspace = [
    "1, monitor:DP-1, persistent:true, default:true"
    "6, monitor:DP-2, persistent:true, default:true"
  ]
  ++ (
    builtins.concatLists (builtins.genList (
      x: [ "${builtins.toString (x+2)}, monitor:DP-1" ]
    ) 4)
  )
  ++ (
    builtins.concatLists (builtins.genList (
      x: [ "${builtins.toString (x+7)}, monitor:DP-2" ]
    ) 3)
  );
};
}
