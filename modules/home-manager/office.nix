{ pkgs, ... }:

{
  # Packages to be installed
  home.packages = with pkgs; [
    onlyoffice-bin
    python3 python311Packages.pygments
    (texlive.combine { inherit (texlive) scheme-medium minted cancel wrapfig tabularray enumitem xpatch datetime2 datetime2-english datetime2-german; })
    texstudio unstable.typst
    unstable.obsidian rnote xournalpp pandoc
    geogebra6 speedcrunch
    megasync rclone
    tigervnc vlc spotify
  ];

  # Change displayed places folders
  xdg.userDirs = {
    enable = true;
    music = null;
    pictures = null;
    publicShare = null;
    videos = null;
  };
}
