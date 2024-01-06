# IMPORTANT: If some error with python and arch-version of systemd
# comes up when trying to rebuild, use '--install-bootloader'

{ config, pkgs, ... }:

{
  imports = let modules = "../../modules/nixos"; in [
    ./hardware-configuration.nix
    ./${modules}/basic-configuration.nix
    ./${modules}/packages.nix
    ./${modules}/steam.nix
  ];

  # Networking
  networking = {
    hostName = "flopsi-desktop-nix";
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };

  # X11 windowing system
  services.xserver = {
    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}