{ lib, pkgs, ... }:

with lib.hm.gvariant;
{
  home.packages = with pkgs; [
    gnome-text-editor gnome.file-roller
    onlyoffice-bin
    python3 python311Packages.pygments
    (texlive.combine { inherit (texlive) scheme-medium minted cancel wrapfig tabularray enumitem xpatch datetime2 datetime2-english datetime2-german; })
    texstudio
    obsidian xournalpp pandoc
    geogebra6 speedcrunch
    rclone
    tigervnc vlc spotify
    zoom-us
  ];

  home.file.".local/bin/eth-setup1.sh".source = ../../files/eth-setup1.sh;

  # Change displayed places folders
  xdg = {
    userDirs = {
      enable = true;
      music = null;
      pictures = null;
      publicShare = null;
      videos = null;
    };
    desktopEntries.eth-setup1 = {
      type = "Application";
      name = "ETH Setup 1";
      comment = "Open Firefox, Obsidian and Gnome Text Editor";
      exec = "eth-setup1.sh";
      categories = [ "Office" "Utility" ];
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

  dconf.settings = {
    "org/gnome/TextEditor" = {
      discover-settings = true;
      highlight-current-line = true;
      indent-style = "space";
      restore-session = true;
      show-line-numbers = true;
      show-map = true;
      style-variant = "dark";
      tab-width = mkUint32 2;
    };
  };

  programs = {
    feh.enable = true;
    yt-dlp.enable = true;
  };

  services.megasync.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications."application/pdf" = "firefox.desktop";
    defaultApplications."text/plain" = "org.gnome.TextEditor.desktop";
    defaultApplications."image/jpeg" = "feh.desktop";
    defaultApplications."image/png" = "feh.desktop";
    defaultApplications."image/bmp" = "feh.desktop";
  };
}
