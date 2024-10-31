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
in
{
  nixosConfigurations = {
    flopsi-desktop-nix = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs; };
      modules = let machine = "machines/desktop"; in [
        ./${machine}/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit pkgs; };
            users.flopsi = import ./${machine}/home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
    flopsi-framework-nix = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs; };
      modules = let machine = "machines/framework"; in [
        ./${machine}/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit pkgs; };
            users.flopsi = import ./${machine}/home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
};
}
