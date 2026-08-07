{
  description = "daviiiL's darwin flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixviii.url = "github:daviiiL/nixviii";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [];

      systems = [
        "aarch64-darwin"
      ];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };

      flake = let
        inherit (inputs) self nixpkgs nix-darwin home-manager;
        inherit (self) outputs;
      in {
        darwinConfigurations = {
          neptune = nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit inputs self outputs;
            };
            modules = [
              ./hosts/neptune/configuration.nix
            ];
          };
        };

        homeConfigurations = {
          "davidliu@neptune" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            extraSpecialArgs = {inherit inputs outputs;};
            modules = [
              ./hosts/neptune/home.nix
            ];
          };
        };
      };
    };
}
