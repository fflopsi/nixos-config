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
    wofi
    brightnessctl
    pamixer playerctl pavucontrol
    networkmanagerapplet
    grimblast
    hypridle
    wl-clipboard
    udiskie
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
};

gtk = {
  enable = true;
  theme = {
    package = pkgs.adw-gtk3;
    name = "adw-gtk3-dark";
    #package = pkgs.gnome.gnome-themes-extra;
    #name = "Adwaita-dark";
  };
  iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus";
  };
  #font = {
  #  name = "FreeSans Regular";
  #  package = pkgs.freefont_ttf;
  #};
  #cursorTheme = {
  #  package = pkgs.graphite-cursors;
  #  name = "graphite-dark";
  #  size = 16;
  #};
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
      "waybar & (sleep 5 && megasync)"
      #"hypridle" # DON'T or else hyprlock will be mad
      "nm-applet"
      "wl-paste --watch cliphist store"
      "udiskie &"
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
      "$mod, V, exec, pkill wofi || cliphist list | wofi -S dmenu | cliphist decode | wl-copy"
      "CONTROL ALT, return, exec, kitty"
      "CONTROL SHIFT, escape, exec, kitty btop"
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
      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
        vibrancy = 0.1696;
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
      "float, title:\\.blueman-manager-wrapped$"
      "move 100%-w-6 40, title:\\.blueman-manager-wrapped$"
      "float, title:Volume Control$"
      "move 100%-w-6 40, title:Volume Control"
      "float, title:Network Connections$"
      "idleinhibit focus, title:Spotify$"
      "idleinhibit fullscreen, title:(.*) Mozilla Firefox$"
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
        disable_loading_bar = false;
        grace = 0;
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
          position = "0, -150";
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
        spacing = 16;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "backlight" "pulseaudio" "bluetooth" "network" "battery" "tray" ];
        "hyprland/window" = {
          icon = true;
        };
        clock = {
          format = "{:%a, %d. %b %Y     %T}";
          interval = 1;
          tooltip-format = "{calendar}";
          actions = {
            on-click = "mode";
          };
          calendar = {
            weeks-pos = "left";
          };
        };
        battery = {
          states = {
            warning = 25;
            critical = 10;
          };
        };
        backlight = {
          format = "🔆 {percent}%";
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
          format-muted = "Muted: {volume}%";
          on-click = "pamixer -t";
          on-click-right = "pavucontrol";
        };
        tray = {
          spacing = 12;
        };
      };
    };
    style = ''
      #workspaces button.active {
        background-color: darkgreen;
      }
      #battery.warning {
        color: black;
        background-color: darkorange;
      }
      #battery.critical {
        background-color: darkred;
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
    '';
  };
};

services = {
  blueman-applet.enable = true;
  cliphist.enable = true;

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
