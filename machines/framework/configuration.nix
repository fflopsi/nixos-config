# IMPORTANT: If some error with python and arch-version of systemd
# comes up when trying to rebuild, use '--install-bootloader'

{ pkgs, ... }:

{
imports = let modules = "../../modules/nixos"; in [
  ./hardware-configuration.nix
  ./${modules}/configuration-hyprland.nix
];

networking.hostName = "flopsi-framework-nix";

# Configure keymap in X11
services.xserver = {
  xkb = {
    layout = "us";
    variant = "altgr-intl";
    options = "lv3:ralt_switch";
  };
};

console.keyMap = "us";

# Use a new enough kernel for the laptop
boot.kernelPackages = pkgs.linuxPackages_latest;

# Enable fingerprint reader
services.fprintd = {
  enable = true;
  #package = pkgs.fprintd-tod;
  #tod = {
  #  enable = true;
  #  driver = pkgs.libfprint-2-tod1-goodix; # Somehow does not work
  #};
};
}
