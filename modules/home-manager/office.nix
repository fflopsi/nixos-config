{ pkgs, ... }:

{
  # Packages to be installed
  home.packages = with pkgs; [
    onlyoffice-bin
    python3 python311Packages.pygments
    (texlive.combine { inherit (texlive) scheme-medium minted cancel wrapfig tabularray xpatch datetime2 datetime2-english datetime2-german; })
    texstudio unstable.typst
    unstable.obsidian rnote xournalpp pandoc
    geogebra6 speedcrunch
    megasync rclone
    tigervnc vlc
  ];

  # Change displayed places folders
  home.file.".config/user-dirs.dirs".source = ../../files/user-dirs.dirs;
}
