{ ... }:

{
services.flatpak = {
  enable = true;
  uninstallUnmanaged = true;
  packages = [
    "com.github.tchx84.Flatseal"
  ];
};
}
