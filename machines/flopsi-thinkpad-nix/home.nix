{ config, osConfig, pkgs, ... }:

{
  home.username = "flopsi";
  home.homeDirectory = "/home/flopsi";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages to be installed
  home.packages = with pkgs; [
    onlyoffice-bin
    texliveMedium texstudio unstable.typst
    unstable.obsidian rnote xournalpp
    geogebra6
    megasync rclone
    terminus-nerdfont papirus-icon-theme adw-gtk3
    android-studio jetbrains.idea-community jetbrains.pycharm-community
    gnome-secrets gnome-browser-connector
    gnomeExtensions.quick-settings-tweaker gnomeExtensions.gnome-40-ui-improvements
    iio-sensor-proxy
  ];
  
  #home.activation = {
  #  installFlatpaks = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #    $DRY_RUN_CMD flatpak remote-add --if-not-exists $VERBOSE_ARG flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  #    $DRY_RUN_CMD flatpak install flathub md.obsidian.Obsidian $VERBOSE_ARG
  #  '';
  #};
  
  # Add ~/.local/bin to path (for user-specific scripts)
  home.sessionPath = [ "$HOME/.local/bin" ];
  
  # Add script to change Gnome theme quickly
  home.file.".local/bin/change-theme".source = ../../scripts/change-theme;
  
  # Autostart megasync
  home.file.".config/autostart/megasync.desktop".source = ../../config/megasync.desktop;
  
  # Bash
  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" "erasedups" ];
    historyIgnore = [ "exit" "clear" ];
    shellAliases = {
      ll = "ls -l";
      la = "ls -lA";
      gedit = "gnome-text-editor";
      console = "kgx";
      ls = "ls --color=auto";
      diff = "diff --color=auto";
      grep = "grep --color=auto";
      ip = "ip --color=auto";
    };
    bashrcExtra = "mkdircd () { mkdir -p $1 && cd $1; }";
  };
  
  # Readline config for bash history search
  programs.readline = {
    enable = true;
    includeSystemConfig = true;
    bindings = {
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
  };
  
  # Oh my Posh prompt
  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
    #useTheme = "powerlevel10k_lean";
    settings = import ../../config/omp_theme.nix;
  };

  # Git
  programs.git = {
    enable = true;
    userName  = "fflopsi";
    userEmail = "florian.l.frauenfelder@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "libsecret";
    };
  };

  # Dconf settings for Gnome
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      calculator = [ "<Super>c" ];
      control-center = [ "<Super>i" ];
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/" ];
      home = [ "<Super>e" ];
      www = [ "<Super>b" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>dead_circumflex";
      command = "change-theme";
      name = "Change theme";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Control><Alt>k";
      command = "secrets";
      name = "Gnome Secrets";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Control><Super>r";
      command = "reboot";
      name = "Reboot";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Shift><Control>Escape";
      command = "kgx -- btop";
      name = "System monitor";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      binding = "<Control><Alt>Return";
      command = "kgx";
      name = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      binding = "<Control><Super>l";
      command = "gnome-session-quit";
      name = "Logout";
    };
    
    "org/gnome/shell" = {
      favorite-apps = [ "firefox.desktop" "org.gnome.Nautilus.desktop" "com.github.flxzt.rnote.desktop" "com.github.xournalpp.xournalpp.desktop" "obsidian.desktop" ];
    };

    "org/gnome/desktop/interface" = {
      monospace-font-name = "Terminess Nerd Font Mono Regular 14";
      icon-theme = "Papirus";
      enable-hot-corners = false;
      clock-show-weekday = true;
      clock-show-seconds = true;
      show-battery-percentage = true;
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
      dynamic-workspaces = true;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };
  };
}
