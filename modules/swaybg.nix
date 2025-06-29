{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.swaybg;
in
{
  options.programs.swaybg = {
    enable = lib.mkEnableOption "Wallpaper tool for Wayland compositors";

    package = lib.mkPackageOption pkgs "swaybg" { };

    mode = lib.mkOption {
      type = lib.types.str;
      description = ''
        Scaling mode for images: stretch, fill, fit, center, or tile.
      '';
      default = "fill";
    };

    image = lib.mkOption {
      type = lib.types.str;
      description = "Set the background image.";
      default = pkgs.nixos-artwork.wallpapers.catppuccin-mocha.gnomeFilePath;
    };

    systemd.target = lib.mkOption {
      type = lib.types.str;
      description = ''
        The systemd target that will automatically start the swaybg service.
      '';
      default = "graphical-session.target";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.swaybg = {
      description = "Wallpaper tool for Wayland compositors";
      documentation = [ "man:swaybg(1)" ];
      wantedBy = [ cfg.systemd.target ];
      partOf = [ cfg.systemd.target ];
      after = [ cfg.systemd.target ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} -m ${cfg.mode} -i ${cfg.image}";
        Restart = "on-failure";
      };
    };
  };
}
