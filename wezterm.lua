local wezterm = require("wezterm")

return {
    color_scheme = "Tokyo Night",
    font = wezterm.font("CascadiaCodeNF"),
    font_size = 12,
    warn_about_missing_glyphs = true,
    window_decorations = "NONE",
    enable_tab_bar = false,
    enable_csi_u_key_encoding = true,
    initial_rows = 40,
    initial_cols = 100,
    enable_wayland = false,
}
