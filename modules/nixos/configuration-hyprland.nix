{ pkgs, ... }:

{
nix = {
  settings.experimental-features = [ "nix-command" "flakes" ]; # Enable flakes
  optimise.automatic = true; # Optimise nix store by hardlinking
  gc = {
    automatic = true; # Automate garbage collection
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
};

boot.loader = {
  efi.canTouchEfiVariables = true;
  systemd-boot = {
    enable = true;
    configurationLimit = 5; # Maximum of 5 NixOS entries
  };
};

time.timeZone = "Europe/Zurich";

i18n = {
  defaultLocale = "en_US.UTF-8"; # System language
  extraLocaleSettings = { # Formats
    LC_ADDRESS = "de_CH.UTF-8";
    LC_IDENTIFICATION = "de_CH.UTF-8";
    LC_MEASUREMENT = "de_CH.UTF-8";
    LC_MONETARY = "de_CH.UTF-8";
    LC_NAME = "de_CH.UTF-8";
    LC_NUMERIC = "de_CH.UTF-8";
    LC_PAPER = "de_CH.UTF-8";
    LC_TELEPHONE = "de_CH.UTF-8";
    LC_TIME = "de_CH.UTF-8";
  };
};

services = {
  # sddm display manager, works best with Hyprland
  displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  # For automounting disks
  udisks2.enable = true;
  # For trash to work correctly
  gvfs.enable = true;
  # Power button and lid switch behavior
  logind = {
    powerKey = "suspend";
    lidSwitch = "suspend";
  };
  # Enable CUPS
  printing.enable = true;
  # Printer specific fixes
  avahi.enable = true;
  avahi.nssmdns4 = true;
  # Sound
  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Blueman for bluetooth
  blueman.enable = true;
  flatpak.enable = true;
};

networking.networkmanager.enable = true;
networking.networkmanager.ensureProfiles.profiles = {
  ethvpn = {
    connection = {
      id = "ETH VPN";
      type = "vpn";
      autoconnect = false;
    };
    vpn = {
      service-type = "org.freedesktop.NetworkManager.openconnect";
      gateway = "sslvpn.ethz.ch/student-net";
      protocol = "anyconnect";
      useragent = "AnyConnect";
    };
  };
};

programs.hyprland = {
  enable = true;
  withUWSM = true;
};
security.pam.services.hyprlock = {};
programs.ydotool.enable = true;

# Enable sound
security.rtkit.enable = true;

hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
};

users.users.flopsi = {
  isNormalUser = true;
  description = "Florian Frauenfelder";
  extraGroups = [ "networkmanager" "wheel" "ydotool" ];
};

# List packages installed in system profile
environment = {
  systemPackages = with pkgs; [
    firefox libreoffice nano fastfetch
    btop tldr gitFull inetutils wget curl sl
  ];
  pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
};

# Sudo insults
security.sudo.package = pkgs.sudo.override { withInsults = true; };

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
system.stateVersion = "23.05"; # Did you read the comment?
}
