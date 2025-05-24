{ pkgs, ... }:

let
  cpSnippets = pkgs.writeShellScriptBin "cp-snippets" (builtins.readFile ../../files/cp-snippets);
in {
home.packages = with pkgs; [
  nautilus file-roller gnome-disk-utility zip unzip
  bitwarden-desktop
  thunderbird discord vesktop
  onlyoffice-bin
  python3 python311Packages.pygments
  (texlive.combine { inherit (texlive) scheme-medium minted cancel wrapfig tabularray enumitem xpatch datetime2 datetime2-english datetime2-german; })
  texstudio
  obsidian xournalpp pandoc
  anki
  nextcloud-client
  geogebra6 speedcrunch
  rclone
  tigervnc vlc spotify
  zoom-us
  inotify-tools nil texlab
] ++ [ cpSnippets ];

home.file.".local/bin/eth-setup1.sh".source = ../../files/eth-setup1.sh;

# Change displayed places folders
xdg = {
  userDirs = {
    enable = true;
    desktop = null;
    music = null;
    pictures = null;
    videos = null;
  };
  mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "firefox.desktop";
      "text/plain" = "dev.zed.Zed.desktop";
      "image/jpeg" = "feh.desktop";
      "image/png" = "feh.desktop";
      "image/bmp" = "feh.desktop";
    };
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
      indent_size = 2;
      quote_type = "single";
    };
  };
};

programs = {
  feh.enable = true;
  yt-dlp.enable = true;

  zed-editor = {
    enable = true;
    userSettings = {
      base_keymap = "JetBrains";
      theme = {
        mode = "system";
        dark = "Ayu Dark";
        light = "Ayu Light";
      };
      tab_size = 2;
      autosave = "on_focus_change";
      format_on_save = "off";
      soft_wrap = "editor_width";
      ui_font_size = 16;
      buffer_font_size = 16;
      git.inline_blame.enabled = false;
      languages = {
        JavaScript.prettier = {
          allowed = true;
          singleQuote = true;
          jsxSingleQuote = true;
        };
        TypeScript = {
          code_actions_on_format."source.organizeImports" = true;
          prettier = {
            allowed = true;
            singleQuote = true;
            jsxSingleQuote = true;
          };
        };
        TSX = {
          code_actions_on_format."source.organizeImports" = true;
          prettier = {
            allowed = true;
            singleQuote = true;
            jsxSingleQuote = true;
          };
        };
      };
    };
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          ctrl-y = "editor::Redo";
          alt-up = "editor::MoveLineUp";
          ctrl-w = "pane::CloseActiveItem";
          alt-down = "editor::MoveLineDown";
        };
      }
    ];
    extensions = [ "git-firefly" "nix" "basher" "latex" "java" "kotlin" "xml" "csv" "log" "scss" ];
  };
};

systemd.user.services.copy-latex-snippets = {
  Unit = {
    Description = "Copy Obsidian LaTeX Suite snippets to Obsidian vault upon changes in git repo";
    After = "graphical-session.target";
    Wants = "graphical-session.target";
  };
  Service = {
    ExecStart = "${cpSnippets}/bin/cp-snippets";
    Restart = "on-failure";
  };
  Install = {
    WantedBy = [ "graphical-session.target" ];
  };
};
}
