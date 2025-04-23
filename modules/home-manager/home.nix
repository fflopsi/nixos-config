{ pkgs, ... }:

{
imports = [
  ./hypr.nix
  ./office.nix
  ./coding.nix
  ./bash.nix
];

nix = {
  gc = {
    automatic = true; # Automate garbage collection
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };
};

home = {
  username = "flopsi";
  homeDirectory = "/home/flopsi";
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  stateVersion = "23.05";
  packages = with pkgs; [
    wofi
    brightnessctl
    pamixer playerctl pavucontrol
    networkmanagerapplet
    wl-clipboard
    udiskie
    dconf
  ];
  # Add ~/.local/bin to path (for user-specific scripts)
  sessionPath = [ "$HOME/.local/bin" ];
  pointerCursor = {
    gtk.enable = true;
    package = pkgs.graphite-cursors;
    name = "graphite-dark";
    size = 16;
  };
  file.".local/bin/change-theme".source = ../../files/change-theme;
};

gtk = {
  enable = true;
  theme = {
    package = pkgs.adw-gtk3;
    name = "adw-gtk3-dark";
  };
  iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus";
  };
};

fonts.fontconfig = {
  enable = true;
  defaultFonts = {
    monospace = [ "Terminess Nerd Font Mono Regular" ];
  };
};

programs = {
  home-manager.enable = true;
  fastfetch.enable = true;
  micro.enable = true;

  btop = {
    enable = true;
    settings = {
      color_theme = "adapta";
      theme_background = false;
      update_ms = 1000;
    };
  };

  kitty = {
    enable = true;
    font = {
      name = "Terminess Nerd Font Mono Regular";
      size = 12;
      package = pkgs.terminus-nerdfont;
    };
  };

  wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
    ];
  };

  waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 8;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "bluetooth"
          "network"
          "pulseaudio"
          "backlight"
          "battery" ];
        "hyprland/window".icon = true;
        clock = {
          format = "{:L%a, %d. %b %Y    %T}";
          locale = "de_CH.UTF-8";
          interval = 1;
          tooltip-format = "{calendar}";
          actions.on-click = "mode";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "left";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };
        battery = {
          format = "{icon} {capacity:2}%";
          format-icons = [ "🪫" "🔋" "🔋" "🔋" ];
          format-charging = "🔌 {capacity:2}%";
          states = {
            low = 49;
            warning = 24;
            critical = 9;
          };
          interval = 5;
        };
        backlight = {
          format = "{icon} {percent:2}%";
          format-icons = [ "🔅" "🔆" ];
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "Cable";
          format-disconnected = "?";
          tooltip-format-wifi = "{frequency} GHz, {bandwidthTotalBytes} on {ipaddr}";
          tooltip-format-ethernet = "{bandwidthTotalBytes} on {ipaddr}";
          tooltip-format-disconnected = "Disconnected";
          interval = 10;
        };
        bluetooth = {
          format-connected = " {status}: {device_alias}";
          tooltip-format-connected = "{status} to {device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}";
        };
        pulseaudio = {
          format = "{icon} {volume:2}%";
          format-muted = "🔇 {volume:2}%";
          format-icons.default = [ "🔈" "🔉" "🔊" ];
          on-click = "pamixer -t";
          on-click-right = "pavucontrol";
        };
        tray.spacing = 12;
      };
    };
    style = ''
      * {
        font-family: monospace;
      }
      .modules-center {
        margin-left: 32px;
        margin-right: 32px;
      }
      .modules-right label.module {
        padding-left: 8px;
        padding-right: 8px;
        border-radius: 6px;
      }
      #workspaces button.active {
        color: white;
        background-color: darkgreen;
      }
      #battery {
        color: white;
        font-weight: bold;
        background-color: darkgreen;
        animation: 0;
      }
      #battery.low {
        color: black;
        background-color: goldenrod;
      }
      #battery.warning {
        color: black;
        background-color: darkorange;
      }
      #battery.critical {
        background-color: darkred;
        animation: 0;
      }
      @keyframes blink {
        to { background-color: black; }
      }
      #battery.critical:not(.charging) {
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: steps(12);
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
      #backlight {
        font-weight: bold;
      }
      #network {
        color: white;
      }
      #network.wifi {
        background-color: darkslateblue;
      }
      #network.ethernet {
        background-color: darkgreen;
      }
      #network.disconnected {
        color: black;
        background-color: darkorange;
      }
      #network.disabled {
        background-color: dimgrey;
      }
      #pulseaudio {
        color: white;
        background-color: #224422
      }
      #pulseaudio.muted {
        background-color: #442222;
      }
      #tray {
        border: 1px solid grey;
        padding-left: 8px;
        padding-right: 8px;
        border-radius: 6px;
      }
    '';
  };
};

services = {
  blueman-applet.enable = true;
  cliphist.enable = true;
  gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "20x20";
        origin = "top-right";
        transparency = 10;
        #frame_color = "#eceff1";
        font = "Droid Sans 10";
      };
    };
  };
};
}
