{ lib, pkgs, ... }:

with lib.hm.gvariant;
{
home.packages = with pkgs; [
  gnome.nautilus gnome.file-roller
  unstable.zed-editor
  onlyoffice-bin
  python3 python311Packages.pygments
  (texlive.combine { inherit (texlive) scheme-medium minted cancel wrapfig tabularray enumitem xpatch datetime2 datetime2-english datetime2-german; })
  texstudio
  obsidian xournalpp pandoc
  geogebra6 speedcrunch
  rclone
  tigervnc vlc spotify
  zoom-us
  inotify-tools
];

home.file.".local/bin/eth-setup1.sh".source = ../../files/eth-setup1.sh;
home.file.".local/bin/cp-snippets".source = ../../files/cp-snippets;

# Change displayed places folders
xdg = {
  userDirs = {
    enable = true;
    music = null;
    pictures = null;
    publicShare = null;
    videos = null;
  };
  mimeApps = {
    enable = true;
    defaultApplications."application/pdf" = "firefox.desktop";
    defaultApplications."text/plain" = "dev.zed.Zed.desktop";
    defaultApplications."image/jpeg" = "feh.desktop";
    defaultApplications."image/png" = "feh.desktop";
    defaultApplications."image/bmp" = "feh.desktop";
  };
  desktopEntries.eth-setup1 = {
    type = "Application";
    name = "ETH Setup 1";
    comment = "Open Firefox, Obsidian and Zed";
    exec = "eth-setup1.sh";
    categories = [ "Office" "Utility" ];
  };
  portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };
};

editorconfig = {
  enable = true;
  settings = {
    "*" = {
      charset = "utf-8";
      end_of_line = "lf";
      trim_trailing_whitespace = true;
      insert_final_newline = true;
      max_line_width = 78;
      indent_style = "space";
      indent_size = 4;
    };
    "*.nix" = {
      indent_size = 2;
    };
  };
};

programs = {
  feh.enable = true;
  yt-dlp.enable = true;

  #zed-editor = {
  #  enable = true;
  #  package = pkgs.unstable.zed-editor;
  #  userSettings = {
  #    base_keymap = "JetBrains";
  #    theme = "Andromeda";
  #  };
  #  extensions = [ "nix" "xy-zed" ];
  #};
};

services.megasync.enable = true;
systemd.user.services.megasync.Service.ExecStartPre = "/run/current-system/sw/bin/sleep 2";

systemd.user.services.copy-latex-snippets = {
  Unit = {
    Description = "Copy Obsidian LaTeX Suite snippets to Obsidian vault upon changes in git repo";
    After = "default.target";
  };
  Service = {
    ExecStart = "%h/.local/bin/cp-snippets";
    Restart = "on-failure";
  };
  Install = {
    WantedBy = [ "default.target" ];
  };
};
}
