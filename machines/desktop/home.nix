{ config, osConfig, pkgs, lib, ... }:

with lib.hm.gvariant;
{
  imports = let modules = "../../modules/home-manager"; in [
    ./${modules}/home.nix
    ./${modules}/gaming.nix
  ];

  # Keyboard layout
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us+altgr-intl" ]) ];
      xkb-options = [ "lv3:ralt_switch" ];
    };
  };
}
