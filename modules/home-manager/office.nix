{ pkgs, ... }:

{
  # Packages to be installed
  home.packages = with pkgs; [
    onlyoffice-bin
    python3 python311Packages.pygments
    (texlive.combine { inherit (texlive) scheme-medium minted cancel wrapfig xpatch datetime2 datetime2-english datetime2-german; })
    texstudio unstable.typst
    unstable.obsidian rnote xournalpp
    geogebra6
    megasync rclone
  ];

  # Autostart megasync
  home.file.".config/autostart/megasync.desktop".source = ../../files/megasync.desktop;
}
