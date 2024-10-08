{ config, pkgs, ... }:

{
  # Who am I, and where do I live?
  home.username = "eotsn";
  home.homeDirectory = "/home/eotsn";

  imports = [ ./emacs-vterm.nix ];

  home.packages = with pkgs; [
    neovim
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xresources.properties = {
    "Xft.dpi" = 192;
  };

  programs.fish = {
    enable = true;
  };

  programs.emacs = {
    enable = true;
    package = ((pkgs.emacsPackagesFor pkgs.emacs-unstable).emacsWithPackages (
      epkgs: with epkgs; [
        avy
	keycast
	vterm
	treesit-grammars.with-all-grammars
      ]
    ));
  };

  programs.git = {
    enable = true;
    userName = "Eric Ottosson";
    userEmail = "4204520+eotsn@users.noreply.github.com";
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}
