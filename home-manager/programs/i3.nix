{ config, lib, pkgs, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      defaultWorkspace = "workspace number 1";
      fonts = {
        names = [ "Iosevka" ];
        style = "Bold Semi-Condensed";
        size = 10.0;
      };
      bars = [
        {
          # Use the same font for both window titles and the status bar.
          fonts = config.xsession.windowManager.i3.config.fonts;
          statusCommand = "${pkgs.i3status}/bin/i3status";
        }
      ];
      keybindings =
        let
          modifier = config.xsession.windowManager.i3.config.modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+Shift+e" = "exec --no-startup-id xfce4-session-logout";
          "${modifier}+Shift+x" = "exec --no-startup-id xflock4";

          # Move focused workspace between monitors
          "${modifier}+Ctrl+Right" = "move workspace to output right";
          "${modifier}+Ctrl+Left" = "move workspace to output left";

          # We replace i3-sensible-terminal with wezterm because $TERMINAL is not
          # available unless we let Home Manager manage our X session, which
          # breaks the nixos XFCE session manager.
          "${modifier}+Return" = "exec wezterm";

          # Use wpctl to adjust volume in PipeWire
          "XF86AudioRaiseVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ 10%+ --limit 1.0";
          "XF86AudioLowerVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ 10%-";
          "XF86AudioMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SOURCE@ toggle";

          # Use brightnessctl to adjust screen brightness
          "XF86MonBrightnessUp" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
          "XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";

          # Use playerctl for media controls
          "XF86AudioPlay" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPause" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec --no-startup-id ${pkgs.playerctl}/bin/playerctl previous";
        };
      startup = [
        { command = "${pkgs.picom}/bin/picom -b --backend xrender --vsync"; notification = false; }
        { command = "${pkgs.xwallpaper}/bin/xwallpaper --daemon --zoom ${../../resources/background.jpg}"; always = true; notification = false; }
      ];
    };
    extraConfig = ''
      for_window [title="Picture-in-Picture"] sticky enable
    '';
  };

  programs.i3status = {
    enable = true;
    enableDefault = false;
    modules = {
      "disk /" = {
        position = 1;
        settings = { format = "node_modules: %used"; };
      };

      "wireless _first_" = {
        position = 2;
        settings = {
          format_up = "W: (%quality) Leaked IP: %ip";
          format_down = "W: down";
        };
      };

      "ethernet _first_" = {
        position = 3;
        settings = {
          format_up = "E: %ip (%speed)";
          format_down = "E: down";
        };
      };

      "battery all" = {
        position = 4;
        settings = { format = "%status %percentage"; };
      };

      "memory" = {
        position = 5;
        settings = { format = "Brain Capacity: %percentage_free"; };
      };

      "tztime local" = {
        position = 6;
        settings = { format = "%Y-%m-%d %H:%M:%S"; };
      };
    };
  };
}
