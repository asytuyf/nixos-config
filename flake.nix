{
  description = "Abdo's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs:
  let
    # Helper function to create a NixOS config for any architecture
    mkSystem = system: nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.abdo = import ./home/abdo.nix;
        }
      ];
    };
  in {
    nixosConfigurations = {
      # x86_64 (Intel/AMD) - for regular PCs and VMs
      nixos = mkSystem "x86_64-linux";

    };
  };
}
