{ pkgs, ... }:

{
home = {
  packages = with pkgs; [
    hypridle
    hyprpolkitagent
    hyprland-qtutils
    hyprpicker
    hyprshot
    hyprsysteminfo
  ];
  # Lockscreen wallpaper
  file.".config/hypr/hyprlock-bg.png".source = ../../files/nix-wallpaper-gear.png;
};

wayland.windowManager.hyprland = {
  enable = true;
  settings = {
    "$mod" = "SUPER";
    exec-once = [
      "waybar"
      "sleep 5 && nextcloud"
      # DON'T or else hyprlock will be mad
      # "hypridle"
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
      "$mod, E, exec, nautilus"
      "$mod, F, togglefloating,"
      "$mod, J, togglesplit,"
      "$mod, L, exec, loginctl lock-session"
      "$mod, O, hyprexpo:expo, toggle"
      "$mod, P, pseudo,"
      "$mod, Q, killactive,"
      "$mod, R, exec, pkill wofi || wofi -S run"
      "$mod, S, exec, systemctl suspend"
      "$mod, T, exec, zeditor"
      "$mod, V, exec, pkill wofi || cliphist list | wofi -S dmenu | cliphist decode | wl-copy && sleep 0.2 && ydotool key 29:1; ydotool key 47:1; ydotool key 47:0; ydotool key 29:0"
      "$mod, W, exec, pkill waybar || waybar"
      "$mod SHIFT, L, exit,"
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
      "CONTROL ALT, return, exec, kitty"
      "CONTROL ALT, 0, exec, change-theme"
      "CONTROL ALT, delete, exec, wlogout"
      "CONTROL SHIFT, escape, exec, kitty btop"
      ", Print, exec, hyprshot -z -m region --clipboard-only"
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
      "float, title:^Bluetooth Devices$"
      "move 100%-w-6 40, title:^Bluetooth Devices$"
      "size 40% 40%, title:^Bluetooth Devices$"
      "float, title:^Volume Control$"
      "move 100%-w-6 40, title:^Volume Control"
      "size 40% 40%, title:^Volume Control"
      "float, title:^Nextcloud$"
      "move 100%-w-6 40, title:^Nextcloud$"
      "size 40% 40%, title:^Nextcloud$"
      "float, title:^Network Connections$"
      "idleinhibit focus, class:^Spotify$"
      "idleinhibit fullscreen, title:^(.*) Mozilla Firefox$"
      "suppressevent maximize, class:.*"
    ];
    plugin.hyprexpo = {
      columns = 3;
      gap_size = 0;
      workspace_method = "first 1";
      enable_gesture = true;
      gesture_fingers = 3;
      gesture_distance = 200;
      gesture_positive = false;
    };
  };
  plugins = with pkgs.hyprlandPlugins; [ hyprexpo ];
};

programs.hyprlock = {
  enable = true;
  settings = {
    general = {
      hide_cursor = true;
      immediate_render = true;
    };
    auth.fingerprint.enabled = true;
    background = [
      {
        path = "$HOME/.config/hypr/hyprlock-bg.png";
        color = "rgb(32, 32, 32)";
        blur_passes = 2;
        blur_size = 8;
      }
    ];
    input-field = [
      {
        size = "250, 50";
        position = "0, -200";
        font_color = "rgb(202, 211, 245)";
        inner_color = "rgb(91, 96, 120)";
        outer_color = "rgb(24, 25, 38)";
        capslock_color = "rgb(255, 255, 0)";
        outline_thickness = 2;
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
        valign = "bottom";
        font_size = "24";
      }
      {
        monitor = "";
        text = "$FPRINTPROMPT";
        text_align = "center";
        position = "0, -250";
        halign = "center";
        valign = "center";
        font_size = "12";
      }
    ];
  };
};

services.hypridle = {
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
}
