# IMPORTANT: If some error with python and arch-version of systemd
# comes up when trying to rebuild, use '--install-bootloader'

{ config, pkgs, ... }:

{
  imports = let modules = "../../modules/nixos"; in [
    ./hardware-configuration.nix
    ./${modules}/configuration.nix
  ];

  networking.hostName = "flopsi-framework-nix";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "lv3:ralt_switch";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Use a new enough kernel for the laptop
  boot.kernelPackages = pkgs.linuxPackages_6_9;

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
