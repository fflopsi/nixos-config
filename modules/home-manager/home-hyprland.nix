{ pkgs, ... }:

{
imports = [
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
    hyprpicker hyprpolkitagent
    wofi
    brightnessctl
    pamixer playerctl pavucontrol
    networkmanagerapplet
    grimblast
    hypridle
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
  # Lockscreen wallpaper
  file.".config/hypr/hyprlock-bg.png".source = ../../files/nix-wallpaper-gear.png;
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

wayland.windowManager.hyprland = {
  enable = true;
  settings = {
    "$mod" = "SUPER";
    exec-once = [
      "waybar"
      "sleep 5 && nextcloud"
      # DON'T or else hyprlock will be mad
      # ^ this was before 24.11, now needs to be started manually
      "hypridle"
      "nm-applet"
      "wl-paste --watch cliphist store"
      "udiskie &"
      "systemctl --user start hyprpolkitagent"
      "dconf write /org/gnome/desktop/interface/color-scheme \"'prefer-dark'\""
      "dconf write /org/gnome/desktop/interface/gtk-scheme \"'adw-gtk3-dark'\""
    ];
    env = [
      "XCURSOR_SIZE, 24"
      "HYPRCURSOR_SIZE, 24"
    ];
    bind = [
      "$mod, B, exec, firefox"
      "$mod, R, exec, pkill wofi || wofi -S run"
      "$mod, T, exec, zeditor"
      ", Print, exec, grimblast copy area"
      "$mod, V, exec, pkill wofi || cliphist list | wofi -S dmenu | cliphist decode | wl-copy && sleep 0.2 && ydotool key 29:1; ydotool key 47:1; ydotool key 47:0; ydotool key 29:0"
      "CONTROL ALT, return, exec, kitty"
      "CONTROL SHIFT, escape, exec, kitty btop"
      "CONTROL ALT, 0, exec, change-theme"
      "CONTROL ALT, delete, exec, wlogout"
      "$mod, S, exec, systemctl suspend"
      "CONTROL ALT $mod, delete, exec, poweroff"
      "CONTROL $mod, R, exec, reboot"
      "$mod, Q, killactive,"
      "$mod, L, exec, loginctl lock-session"
      "$mod SHIFT, L, exit,"
      "$mod, E, exec, nautilus"
      "$mod, F, togglefloating,"
      "$mod, P, pseudo,"
      "$mod, J, togglesplit,"
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod, tab, cyclenext,"
      "ALT, tab, cyclenext,"
      "$mod SHIFT, tab, cyclenext, prev"
      "ALT SHIFT, tab, cyclenext, prev"
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"
      "CONTROL ALT, right, workspace, e+1"
      "CONTROL ALT, left, workspace, e-1"
      ", XF86AudioRaiseVolume, exec, pamixer -i 5"
      ", XF86AudioLowerVolume, exec, pamixer -d 5"
      ", XF86AudioMute, exec, pamixer -t"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
      ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
    ]
    ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]
      )
      10)
    );
    bindr = [
      "$mod, Super_L, exec, pkill wofi || wofi -S drun -I"
    ];
    bindl = [
      ",switch:on:Lid Switch, exec, systemctl suspend"
    ];
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, CONTROL_L, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod, ALT_L, resizewindow"
    ];
    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 1;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
      resize_on_border = true;
      allow_tearing = false;
      layout = "dwindle";
    };
    decoration = {
      rounding = 10;
      active_opacity = 1.0;
      inactive_opacity = 1.0;
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
        vibrancy = 0.1696;
      };
      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };
    };
    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };
    master.new_status = "master";
    misc = {
      allow_session_lock_restore = true;
      force_default_wallpaper = -1;
      disable_hyprland_logo = false;
    };
    input = {
      kb_layout = "us";
      kb_variant = "altgr-intl";
      kb_options = "lv3:ralt_switch";
      numlock_by_default = true;
      follow_mouse = 1;
      accel_profile = "flat";
      sensitivity = 0.5;
      touchpad.natural_scroll = true;
    };
    gestures.workspace_swipe = true;
    windowrulev2 = [
      "float, title:Bluetooth Devices$"
      "move 100%-w-6 40, title:Bluetooth Devices$"
      "float, title:Volume Control$"
      "move 100%-w-6 40, title:Volume Control"
      "float, title:Network Connections$"
      "idleinhibit focus, title:Spotify$"
      "idleinhibit fullscreen, title:(.*) Mozilla Firefox$"
      "float, title:MEGAsync$"
      "move 100%-w-6 40, title:MEGAsync$"
      "suppressevent maximize, class:.*"
    ];
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

  hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 0;
        hide_cursor = true;
        enable_fingerprint = true;
      };
      background = [
        {
          path = "$HOME/.config/hypr/hyprlock-bg.png";
          blur_passes = 2;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          size = "250, 50";
          position = "0, -200";
          monitor = "";
          dots_center = true;
          fade_on_empty = true;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 2;
          placeholder_text = "Password";
          shadow_passes = 2;
        }
      ];
      label = [
        {
          monitor = "";
          text = "cmd[update:1000] date +'%T<br/>%a, %d. %b %Y'";
          text_align = "center";
          position = "0, 200";
          halign = "center";
          valign = "center";
          font_size = "24";
        }
        {
          monitor = "";
          text = "cmd[update:10000] [ -f /sys/class/power_supply/BAT1/capacity ] && echo $(cat /sys/class/power_supply/BAT1/capacity)%";
          text_align = "center";
          position = "0, 10";
          halign = "center";
          font_size = "24";
        }
        {
          monitor = "";
          text = "$FPRINTMESSAGE";
          text_align = "center";
          position = "0, -250";
          halign = "center";
          valign = "center";
          font_size = "12";
        }
      ];
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

  hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 240;
          on-timeout = "brightnessctl -s set 7";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
};
}
