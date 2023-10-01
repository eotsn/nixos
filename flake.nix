{
  description = "";

  nixConfig = {
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    templ = {
      url = "github:a-h/templ";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
    in
    {
      # NixOS configuration entrypoint
      # Available through `nixos-rebuild --flake .#nixos`
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [ ./nixos/configuration.nix ];
      };

      # Home Manager configuration entrypoint
      # Available through `home-manager --flake .#eottosson`
      homeConfigurations.eottosson = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./home-manager/home.nix ];
      };
    };
}
