{
  description = "Home Manager config";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    untracked = {
      type = "file";
      url = "file:///home/maarten/.config/nixpkgs/home-untracked.nix";
      flake = false;
    };
    consul-tunnels = {
      type = "file";
      url = "file:///home/maarten/.config/nixpkgs/consul-tunnels.nix";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, untracked, consul-tunnels, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations.opstop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./homes/opstop.nix
          (import untracked)
          (import consul-tunnels)
        ];
      };
    };
}
