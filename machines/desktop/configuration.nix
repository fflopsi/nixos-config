# IMPORTANT: If some error with python and arch-version of systemd
# comes up when trying to rebuild, use '--install-bootloader'

{ config, pkgs, ... }:

{
  imports = let modules = "../../modules/nixos"; in [
    ./hardware-configuration.nix
    ./${modules}/configuration-hyprland.nix
    ./${modules}/steam.nix
  ];

  # Networking
  networking.hostName = "flopsi-desktop-nix";

  # X11 windowing system
  services.xserver.xkb = {
    # Configure keymap in X11
    layout = "us";
    variant = "altgr-intl";
    options = "lv3:ralt_switch";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Gaming mouse
  services.ratbagd.enable = true;

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
