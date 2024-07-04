{ config, pkgs, ... }:

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

  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      # Use systemd-boot as bootloader
      enable = true;
      configurationLimit = 5;
    };
  };

  # Set time zone
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties
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

  # X11 windowing system
  services.xserver = {
    enable = true;
    # Enable touchpad support (enabled default in most desktopManager)
    # libinput.enable = true;
  };

  networking.networkmanager.enable = true;

  # Hyprland
  programs.hyprland.enable = true;
  security.pam.services.hyprlock = {};

  # Power button and lid switch behavior
  services.logind = {
    powerKey = "suspend";
    lidSwitch = "suspend";
  };

  # Enable CUPS to print documents
  services.printing.enable = true;
  # Enable printer specific fixes
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # Enable sound with pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
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

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Define user account
  users.users.flopsi = {
    isNormalUser = true;
    description = "Florian Frauenfelder";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    topgrade
    firefox thunderbird libreoffice
    micro btop tldr gitFull inetutils wget curl sl
  ];

  # Enable flatpak
  services.flatpak.enable = true;

  # Default apps
  xdg.mime.defaultApplications = {
    "application/pdf" = "firefox.desktop";
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
