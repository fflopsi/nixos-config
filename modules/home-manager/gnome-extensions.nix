{ ... }:

{
dconf.settings = {
  "org/gnome/shell" = {
    enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" "clipboard-indicator@tudmotu.com" "gnome-ui-tune@itstime.tech" "gsconnect@andyholmes.github.io" "quick-settings-tweaks@qwreey" ];
  };

  "org/gnome/shell/extensions/clipboard-indicator" = {
    move-item-first = true;
  };

  "org/gnome/shell/extensions/gnome-ui-tune" = {
    always-show-thumbnails = false;
    hide-search = false;
  };

  "org/gnome/shell/extensions/quick-settings-tweaks" = {
    add-dnd-quick-toggle-enabled = false;
    user-removed-buttons = [ "RfkillToggle" "KeyboardBrightnessToggle" "DarkModeToggle" "NightLightToggle" ];
  };
};
}
