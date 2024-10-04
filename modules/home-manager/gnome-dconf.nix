{ lib, ... }:

with lib.hm.gvariant;
{
# Add script to change Gnome theme quickly
home.file.".local/bin/change-theme".source = ../../files/change-theme;

# Autostart megasync
home.file.".config/autostart/megasync.desktop".source = ../../files/megasync.desktop;

# Dconf settings for Gnome
dconf.settings = let keybinds = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"; in {
  "org/gnome/settings-daemon/plugins/media-keys" = {
    calculator = [ "<Super>c" ];
    control-center = [ "<Super>i" ];
    custom-keybindings = [ "/${keybinds}/custom0/" "/${keybinds}/custom1/" "/${keybinds}/custom2/" "/${keybinds}/custom3/" "/${keybinds}/custom4/" "/${keybinds}/custom5/" "/${keybinds}/custom6/" "/${keybinds}/custom7/" ];
    home = [ "<Super>e" ];
    www = [ "<Super>b" ];
  };

  "${keybinds}/custom0" = {
    binding = "<Control><Alt>0";
    command = "change-theme";
    name = "Change theme";
  };

  "${keybinds}/custom1" = {
    binding = "<Control><Alt>k";
    command = "secrets";
    name = "Gnome Secrets";
  };

  "${keybinds}/custom2" = {
    binding = "<Control><Super>r";
    command = "reboot";
    name = "Reboot";
  };

  "${keybinds}/custom3" = {
    binding = "<Shift><Control>Escape";
    command = "kgx -- btop";
    name = "System monitor";
  };

  "${keybinds}/custom4" = {
    binding = "<Control><Alt>Return";
    command = "kgx";
    name = "Terminal";
  };

  "${keybinds}/custom5" = {
    binding = "<Control><Super>l";
    command = "gnome-session-quit";
    name = "Logout";
  };

  "${keybinds}/custom6" = {
    binding = "<Super>t";
    command = "gnome-text-editor";
    name = "Text Editor";
  };

  "${keybinds}/custom7" = {
    binding = "<Super>s";
    command = "systemctl suspend";
    name = "Suspend";
  };

  "org/gnome/shell/keybindings" = {
    toggle-quick-settings = [];
  };

  "system/locale" = {
    region = "de_CH.UTF-8";
  };

  "org/gnome/shell" = {
    favorite-apps = [ "firefox.desktop" "org.gnome.Nautilus.desktop" "com.github.flxzt.rnote.desktop" "com.github.xournalpp.xournalpp.desktop" "obsidian.desktop" ];
  };

  "org/gnome/desktop/interface" = {
    monospace-font-name = "Terminess Nerd Font Mono Regular 14";
    icon-theme = "Papirus";
    color-scheme = "prefer-dark";
    gtk-theme = "adw-gtk3-dark";
    enable-hot-corners = false;
    clock-show-weekday = true;
    clock-show-seconds = true;
    show-battery-percentage = true;
  };

  "org/gnome/mutter" = {
    workspaces-only-on-primary = false;
    dynamic-workspaces = true;
    experimental-features = [ "scale-monitor-framebuffer" ];
  };

  "org/gnome/shell/app-switcher" = {
    current-workspace-only = true;
  };

  "org/gtk/gtk4/settings/file-chooser" = {
    show-hidden = true;
    sort-directories-first = true;
  };

  "org/gnome/Console" = {
    theme = "auto";
  };

  "org/gnome/TextEditor" = {
    indent-style = "space";
    tab-width = mkUint32 2;
  };

  "org/gnome/calculator" = {
    button-mode = "advanced";
    show-thousands = true;
  };

  "org/gnome/desktop/calendar" = {
    show-weekdate = true;
  };

  "org/gnome/desktop/peripherals/touchpad" = {
    tap-to-click = true;
    accel-profile = "flat";
  };

  "org/gnome/desktop/peripherals/mouse" = {
    accel-profile = "flat";
  };
};
}
