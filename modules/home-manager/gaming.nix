{ pkgs, ... }:

{
home.packages = with pkgs; [
  heroic
  piper
];
}
