{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local config = {
        color_scheme = "Catppuccin Mocha",
        enable_tab_bar = false,
        font = wezterm.font("Iosevka"),
        font_size = 16.0,
      }

      return config
    '';
  };
}
