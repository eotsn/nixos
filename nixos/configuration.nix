{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix.settings = {
    # Enable flakes and new `nix` command.
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store.
    auto-optimise-store = true;
  };

  # Set your hostname.
  networking.hostName = "nixos";

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Enable networking.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Enable the XFCE Desktop Environment but disable XFWM in favor of i3.
    desktopManager.xfce = {
      enable = true;
      noDesktop = true;
      enableXfwm = false;
    };
    windowManager.i3.enable = true;

    displayManager = {
      lightdm = {
        enable = true;
        background = ../resources/background.jpg;
      };
      defaultSession = "xfce+i3";
    };
  };

  # Configure keymap in X11.
  services.xserver = {
    layout = "se,us";
    xkbVariant = ",altgr-intl";
    xkbOptions = "grp:win_space_toggle, ctrl:nocaps";
  };

  # Configure console keymap.
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;

  users.users.eottosson = {
    isNormalUser = true;
    description = "Eric Ottosson";
    shell = pkgs.zsh;
    extraGroups = [ "docker" "networkmanager" "video" "wheel" ];
  };

  fonts.packages = with pkgs; [
    iosevka
  ];

  environment.systemPackages = with pkgs; [
    # 1Password uses KDE wallet to store the 2FA token for accounts with
    # two-factor authentication enabled.
    libsForQt5.kdeFrameworks.kwallet
    kwallet-pam
  ];

  # Unlock KDE wallet on login.
  security.pam.services.lightdm.enableKwallet = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "eottosson" ];
  };

  # Enable virtualization support with Docker.
  virtualisation.docker.enable = true;

  # Enable virtualization.
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "eottosson" ];

  # Intel MIPI/IPU6 webcam-support.
  # hardware.ipu6.enable = true;
  # hardware.ipu6.platform = "ipu6ep";

  # Enable Bluetooth support.
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable Thunderbolt support.
  services.hardware.bolt.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
