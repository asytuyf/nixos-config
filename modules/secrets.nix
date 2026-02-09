{ config, pkgs, ... }:

{
  # Secrets management with sops-nix
  # This makes your secrets encrypted in git but available at runtime
  
  # Install sops for managing secrets
  environment.systemPackages = with pkgs; [
    sops
    age  # Encryption tool used by sops
  ];

  # Configure sops
  sops = {
    # Location of your age key (generated below)
    age.keyFile = "/var/lib/sops-nix/key.txt";
    
    # Default secret file location
    defaultSopsFile = ../secrets/secrets.yaml;
    
    # Define your secrets here (examples)
    secrets = {
      # Example: GitHub token
      # "github-token" = {
      #   owner = "abdo";
      # };
      
      # Example: SSH private key
      # "ssh-private-key" = {
      #   owner = "abdo";
      #   path = "/home/abdo/.ssh/id_ed25519";
      # };
    };
  };
}
