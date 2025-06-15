{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brightnessctl
    fuzzel
    ghostty
    swaybg
    swayidle
    swaylock
    wl-clipboard
    xwayland-satellite
  ];

  programs.niri.enable = true;

  systemd.user.services.swaybg = {
    description = "Wallpaper tool for Wayland compositors";
    wantedBy = [ "niri.service" ];
    requisite = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "/bin/sh -c '${pkgs.swaybg}/bin/swaybg -m mode -i $(find ~/.local/share/wallpapers/ -type f | shuf -n 1)'";
      Restart = "on-failure";
    };
  };

  systemd.user.services.swayidle = {
    description = "Idle management daemon for Wayland";
    wantedBy = [ "niri.service" ];
    requisite = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = ''${pkgs.swayidle}/bin/swayidle -w \
          timeout 300 '${pkgs.swaylock}/bin/swaylock -fe -c 000000' \
          timeout 600 'niri msg action power-off-monitors' \
          timeout 900 'systemctl suspend' \
          before-sleep '${pkgs.swaylock}/bin/swaylock -fe -c 000000'
      '';
      Restart = "on-failure";
    };
  };

  systemd.user.services.mako = {
    description = "Lightweight Wayland notification daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecCondition = "/bin/sh -c '[ -n \"$WAYLAND_DISPLAY\" ]'";
      ExecStart = "${pkgs.mako}/bin/mako";
      ExecReload = "${pkgs.mako}/bin/makoctl reload";
    };
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wants = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };
}
