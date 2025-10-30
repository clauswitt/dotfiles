local M = {}

M.theme_config = {
  dark = {
    -- custom_name = "BlulocoDarkMod",
    foreground = "#b9c0cb",
    background = "#000000",
    cursor_bg = "#ffcc00",
    cursor_border = "#ffcc00",
    cursor_fg = "#282c34",
    selection_bg = "#b9c0ca",
    selection_fg = "#272b33",
    ansi = {"#41444d","#fc2f52","#25a45c","#ff936a","#3476ff","#7a82da","#4483aa","#cdd4e0"},
    brights = {"#8f9aae","#ff6480","#3fc56b","#f9c859","#10b1fe","#ff78f8","#5fb9bc","#ffffff"},
    split = "#777777",
    scrollbar_thumb = "#2b2042",
    tab_bar = {
      background = "#000000",
      active_tab = {
        bg_color = "#2b2042",
        fg_color = "#c0c0c0",
        intensity = "Bold",
        italic = true,
      },
      inactive_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,
        underline = 'Single',
      },
      new_tab = {
        bg_color = "#000000",
        fg_color = "#808080",
      },
      new_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        intensity = "Bold",
      }
    }
  },
  light = {
    -- custom_name = "BlulocoLightMod",
    foreground = "#373a41",
    background = "#ffffff",
    cursor_bg = "#f32759",
    cursor_border = "#f32759",
    cursor_fg = "#ffffff",
    selection_bg = "#daf0ff",
    selection_fg = "#373a41",
    ansi = {"#373a41","#d52753","#23974a","#df631c","#275fe4","#823ff1","#27618d","#babbc2"},
    brights = {"#676a77","#ff6480","#3cbc66","#c5a332","#0099e1","#ce33c0","#6d93bb","#d3d3d3"},
    split = "#777777",
    scrollbar_thumb = "#F0F0F0",
    tab_bar = {
      background = "#ffffff",
      active_tab = {
        bg_color = "#F0F0F0",
        fg_color = "#000000",
        intensity = "Bold",
        italic = true,
      },
      inactive_tab_hover = {
        bg_color = "#E4E4E4",
        fg_color = "#808080",
        italic = true,
        underline = 'Single',
      },
      new_tab = {
        bg_color = "#ffffff",
        fg_color = "#808080",
      },
      new_tab_hover = {
        bg_color = "#E4E4E4",
        fg_color = "#808080",
        intensity = "Bold",
      }
    }
  }
}

return M