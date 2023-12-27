# System flake

{
  description = "Flake for nixos-rebuild flopsi-thinkpad-nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11"; # stable release
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # unstable rolling release
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11"; # stable release
      # url = "github:nix-community/home-manager"; # unstable rolling release
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      flopsi-thinkpad-nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.flopsi = import ./home.nix;
            };
          }
        ];
      };
    };
  };
}
