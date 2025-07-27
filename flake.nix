# System flake

{
description = "Flake for nixos-rebuild";

inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # stable release
  nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # unstable rolling release
  home-manager = {
    url = "github:nix-community/home-manager/release-25.05"; # stable release
    # url = "github:nix-community/home-manager"; # unstable rolling release
    inputs.nixpkgs.follows = "nixpkgs";
  };
  nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
};

outputs = { nixpkgs, nixpkgs-unstable, home-manager, nix-flatpak, ... }:
let
  system = "x86_64-linux";
  # For using pkgs.unstable.<package> instead of unstable.<package>
  overlay = (final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-25.9.0" ]; # For Obsidian
      };
    };
  });
  nixosSystem = machine: nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      {
        nixpkgs = {
          config.allowUnfree = true;
          overlays = [ overlay ];
        };
      }
      ./machines/${machine}/configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            nixpkgs = {
              config.allowUnfree = true;
              overlays = [ overlay ];
            };
            nix-flatpak = nix-flatpak;
          };
          users.flopsi = import ./machines/${machine}/home.nix;
          backupFileExtension = "backup";
        };
      }
      nix-flatpak.nixosModules.nix-flatpak
    ];
  };
in
{
  nixosConfigurations = {
    flopsi-desktop-nix = nixosSystem "desktop";
    flopsi-framework-nix = nixosSystem "framework";
  };
};
}
