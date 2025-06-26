{ config, lib, pkgs, ... }:

let
  overrides = final: prev: {
    lsp-mode = (
      prev.lsp-mode.overrideAttrs (
        f: p: {
          buildPhase = ''
            export LSP_USE_PLISTS=true
          '' + p.buildPhase;
        }
      )
    );
  };
in
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];

  environment.systemPackages = with pkgs; [
    emacs-lsp-booster
  ];

  environment.sessionVariables = {
    LSP_USE_PLISTS = "true";
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = with pkgs; (
      ((emacsPackagesFor emacs-git-pgtk).overrideScope overrides).withPackages (
        epkgs: with epkgs; [
          apheleia
          avy
          cape
          consult
          corfu
          dockerfile-mode
          eat
          embark
          embark-consult
          expand-region
          flycheck
          forge
          go-mode
          gptel
          helpful
          jinx
          lsp-mode
          lsp-tailwindcss
          lsp-ui
          magit
          marginalia
          markdown-mode
          modus-themes
          move-text
          nix-mode
          orderless
          perspective
          terraform-mode
          treesit-grammars.with-all-grammars
          vertico
          wgrep
          yaml-mode
          yasnippet
        ]
      )
    );
  };
}
