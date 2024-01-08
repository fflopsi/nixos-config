{ config, osConfig, pkgs, ... }:

{
  imports = let modules = "../../modules/home-manager"; in [
    ./${modules}/home.nix
  ];
}
