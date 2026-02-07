{
  description = "Abdo's NixOS Configuration";

  inputs = {
    # 1. Define the source of your packages (NixOS 25.11)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # 2. Define Home Manager (Must match the system version)
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # "nixos" is the hostname of your machine (check `hostname` in terminal)
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Adjust if you move to ARM later
        modules = [
          # Import your existing configuration
          ./configuration.nix

          # Import Home Manager Module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            # Pass inputs to home.nix so you can use them there later
            home-manager.extraSpecialArgs = { inherit inputs; };
            
            # Link your specific home.nix
            home-manager.users.abdo = import ./home.nix;
          }
        ];
      };
    };
  };
}