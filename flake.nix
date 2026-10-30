{
  description = "Frank's macOS setup: nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nix-darwin, home-manager, ... }:
    let
      # Change these on a machine where the account or home folder differs.
      user = "fp";
      home = "/Users/frank";
    in
    {
      darwinConfigurations.laptop = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user home; };
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Existing dotfiles in ~ get renamed to *.before-nix instead of blocking the switch.
            home-manager.backupFileExtension = "before-nix";
            home-manager.extraSpecialArgs = { inherit user home; };
            home-manager.users.${user} = import ./nix/home.nix;
          }
        ];
      };
    };
}
