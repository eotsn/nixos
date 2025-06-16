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
      ((emacsPackagesFor emacs-unstable-pgtk).overrideScope overrides).withPackages (
        epkgs: with epkgs; [
          aidermacs
          apheleia
          avy
          cape
          consult
          corfu
          diff-hl
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
          jtsx
          lsp-mode
          lsp-tailwindcss
          lsp-ui
          magit
          marginalia
          markdown-mode
          modus-themes
          move-text
          orderless
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