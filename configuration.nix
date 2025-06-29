{ config, pkgs, ... }:

{
  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/mako.nix
      ./modules/swaybg.nix
      ./modules/swayidle.nix
      ./modules/polkit-gnome.nix
      ./modules/emacs.nix
      ./modules/home.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NVIDIA ---------------------------------------------------------------------

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Use the NVIDIA open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    open = true;
    nvidiaSettings = true; # For nvidia-settings program
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  hardware.nvidia.prime = {
    sync.enable = true; # https://wiki.nixos.org/wiki/NVIDIA#Sync_mode

    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Login and window manger ----------------------------------------------------

  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "us";
    options = "ctrl:nocaps";
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
  #     user = "greeter";
  #   };
  # };

  # A scrollable-tiling Wayland compositor.
  programs.niri.enable = true;

  # Networking -----------------------------------------------------------------

  networking.networkmanager.enable = true;

  networking.hostName = "SE-1HWNBY3";

  # Internationalization -------------------------------------------------------

  time.timeZone = "Europe/Stockholm";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Audio ----------------------------------------------------------------------

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Fonts ----------------------------------------------------------------------

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # User -----------------------------------------------------------------------

  users.users.erico = {
    isNormalUser = true;
    description = "Eric Ottosson";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  # Packages -------------------------------------------------------------------

  nixpkgs.config.allowUnfree = true;

  # Enable Wayland support in Chromium and Electron based applications.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    brightnessctl # Screen brightness
    fuzzel # Wayland-native application launcher
    ghostty # Fast, feature-rich, and cross-platform terminal emulator
    wl-clipboard # Command-line copy/paste utilities for Wayland

    swaybg # Wallpaper tool for Wayland compositors
    swayidle # Idle management daemon for Wayland
    swaylock # Screen locker for Wayland

    pwvucontrol # Pipewire volume control

    adwaita-icon-theme
    papirus-icon-theme

    libnotify # For notify-send program

    hunspell # Spell checker
    hunspellDicts.en_US # Dictionary for English (United states) from Wordlist
    hunspellDicts.sv_SE # Dictionary for Swedish (Sweden) from LibreOffice

    xwayland-satellite # https://github.com/YaLTeR/niri/wiki/Xwayland
  ];

  programs.dconf.profiles.user.databases = [
    {
      lockAll = true; # Prevents overriding
      settings = {
        "org/gnome/desktop/interface" = {
          icon-theme = "Papirus-Dark";
          color-scheme = "prefer-dark";
        };
      };
    }
  ];

  # The user-friendly command line shell.
  programs.fish.enable = true;

  # Highly customizable Wayland bar for Sway and Wlroots based compositors.
  programs.waybar.enable = true;

  # A lightweight Wayland notification daemon.
  programs.mako.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication
    # support, require enabling PolKit integration on some desktop environments
    # (e.g. Plasma).
    polkitPolicyOwners = [ "erico" ];
  };

  programs.swaybg.enable = true;

  programs.swayidle = {
    enable = true;
    events = [
      "timeout 300 '${pkgs.swaylock}/bin/swaylock -fe -c 000000'"
      "timeout 600 '${pkgs.niri}/bin/niri msg action power-off-monitors'"
      "timeout 900 'systemctl suspend'"
      "before-sleep '${pkgs.swaylock}/bin/swaylock -fe -c 000000'"
    ];
  };

  programs.polkit-gnome.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
