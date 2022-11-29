local wezterm = require 'wezterm';

return {
  color_scheme = "Grape",
  -- color_scheme = "MaterialOcean",
  -- font = wezterm.font("JetBrainsMono Nerd Font"),
  font = wezterm.font("Cascadia Code PL"),
  font_size = 13,
  warn_about_missing_glyphs = false,
  window_decorations = "NONE",
  enable_tab_bar = false,
  enable_csi_u_key_encoding = true,
  initial_rows = 40,
  initial_cols = 85,
}
