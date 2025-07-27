{ nix-flatpak, ... }:

{
imports = [
  nix-flatpak.homeManagerModules.nix-flatpak
];

services.flatpak = {
  enable = true;
  uninstallUnmanaged = true;
  overrides.global.Context.filesystems = [
    "xdg-config/git:ro" # Git config
    "/nix/store:ro" # Cursor theme
  ];
  packages = [
    "com.google.AndroidStudio"
    "com.jetbrains.IntelliJ-IDEA-Community"
    "com.jetbrains.IntelliJ-IDEA-Ultimate"
    "com.jetbrains.PyCharm-Community"
    "com.jetbrains.PyCharm-Professional"
    "com.jetbrains.WebStorm"
  ];
};
}
