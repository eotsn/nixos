{ config, pkgs, lib, ...}:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in
{
  imports =
    [ # Enable the NixOS Home Manager module.
      (import "${home-manager}/nixos")
    ];

  home-manager.users.erico = { pkgs, ... }: {
    home.packages = with pkgs; [ git ];

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager
    # release introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you
    # do want to update the value, then make sure to first check the Home
    # Manager release notes.
    home.stateVersion = "25.05"; # Please read the comment before changing.

  };
}
