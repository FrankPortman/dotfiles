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
    # Prebuilt package index for `, <cmd>` and command-not-found suggestions.
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-index-database,
      ...
    }:
    let
      # Must match the Mac's account (`id -un`) and home folder. bootstrap.sh checks.
      user = "fp";
      home = "/Users/frank";
      system = "aarch64-darwin";
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
            home-manager.sharedModules = [ nix-index-database.homeModules.nix-index ];
            home-manager.users.${user} = import ./nix/home.nix;
          }
        ];
      };

      # `nix flake init -t ~/dotfiles` in a project: dev shell + .envrc for direnv.
      templates.default = {
        path = ./templates/devshell;
        description = "Per-project dev shell loaded by direnv";
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
