# System flake

{
description = "Flake for nixos-rebuild";

inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # stable release
  nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; # unstable rolling release
  home-manager = {
    url = "github:nix-community/home-manager/release-24.05"; # stable release
    # url = "github:nix-community/home-manager"; # unstable rolling release
    inputs.nixpkgs.follows = "nixpkgs";
  };
};

outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    # For using pkgs.unstable.<package> instead of unstable.<package>
    overlays = [
      (final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [ "electron-25.9.0" ]; # For Obsidian
          };
        };
      })
    ];
  };
  nixosSystem = machine: nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit pkgs; };
    modules = [
      ./machines/${machine}/configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit pkgs; };
          users.flopsi = import ./machines/${machine}/home.nix;
          backupFileExtension = "backup";
        };
      }
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
