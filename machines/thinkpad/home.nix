{ config, osConfig, pkgs, ... }:

{
  imports = let modules = "../../modules/home-manager"; in [
    ./${modules}/basic-home.nix
    ./${modules}/gnome-dconf.nix
    ./${modules}/gnome-extensions.nix
    ./${modules}/office.nix
    ./${modules}/coding.nix
    ./${modules}/bash.nix
  ];
}
