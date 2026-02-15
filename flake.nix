{
  description = "Eric's NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

 outputs = { self, nixpkgs, home-manager, spicetify-nix, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # 移除原本在這邊的 system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # 在這裡定義 platform 即可消除警告
        { nixpkgs.hostPlatform = "x86_64-linux"; }
        
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.eric = import ./home.nix;
        }
      ];
    };
  };
  
  
