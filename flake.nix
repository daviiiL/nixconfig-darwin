{
  description = "daviiiL's darwin flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # opencode 2.2.5 has a darwin node_modules hash mismatch; drop once fixed upstream.
    nixpkgs-opencode.url = "github:nixos/nixpkgs/aa48d347080940b8a2b8d2f48228674e280a3514";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixviii.url = "github:daviiiL/nixviii";

    # Homebrew: nix-homebrew installs and pins the prefix; taps are pinned as
    # non-flake inputs so `brew tap` is never needed.
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-speedtest = {
      url = "github:teamookla/homebrew-speedtest";
      flake = false;
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}: let
    host = {
      name = "neptune";
      user = "davidliu";
      system = "aarch64-darwin";
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [];

      systems = [host.system];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };

      flake = let
        inherit (inputs) self nixpkgs nix-darwin home-manager;
        inherit (self) outputs;
      in {
        overlays.default = import ./overlays {inherit inputs;};

        darwinConfigurations = {
          ${host.name} = nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit inputs self outputs host;
            };
            modules = [
              inputs.nix-homebrew.darwinModules.nix-homebrew
              ./hosts/${host.name}/configuration.nix
            ];
          };
        };

        homeConfigurations = {
          "${host.user}@${host.name}" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${host.system};
            extraSpecialArgs = {inherit inputs outputs host;};
            modules = [
              ./hosts/${host.name}/home.nix
            ];
          };
        };
      };
    };
}
