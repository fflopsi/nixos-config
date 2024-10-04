{ config, osConfig, pkgs, ... }:

{
home.packages = with pkgs; [
  heroic
  discord vesktop
  piper
];
}
