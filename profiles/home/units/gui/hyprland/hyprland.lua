---@diagnostic disable: undefined-global

--###############
--## MONITORS ###
--###############

-- hl.monitor({
--   output = "",
--   mode = "preferred",
--   position = "auto",
--   scale = "1",
-- })

--##################
--## MY PROGRAMS ###
--##################

local terminal = "alacritty"
local fileManager = "thunar"
local menu = "rofilauncher"
local browser = "firefox"
local calculator = "qalculate-gtk"

--################
--## AUTOSTART ###
--################

hl.on("hyprland.start", function()
  hl.exec_cmd("Enpass -minimize")
  hl.exec_cmd("signal-desktop --start-in-tray")
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("udiskie --tray --automount --notify")
  hl.exec_cmd("systemctl --user start hyprpaper")
end)

--############################
--## ENVIRONMENT VARIABLES ###
--############################

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Numix-Cursor")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Numix-Cursor")

--############################
--######### GENERAL ##########
--############################

hl.config({
  general = {
    gaps_in = 2,
    gaps_out = 2,
    border_size = 4,
    col = {
      active_border = {
        colors = { "rgba(bfd7e6ff)", "rgba(38bdf8ff)" },
        angle = 45,
      },

      inactive_border = "rgba(121a24cc)", -- dark navy steel
    },
    resize_on_border = true,
    allow_tearing = false,
  },

  decoration = {
    rounding = 5,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = false,
  },

  master = {
    new_status = "master",
  },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    background_color = 0,
  },

  input = {
    kb_layout = "us,si",
    kb_variant = "",
    kb_model = "",
    kb_options = "caps:swapescape,grp:win_space_toggle",
    kb_rules = "",
    repeat_rate = 50,
    repeat_delay = 180,
    numlock_by_default = true,
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = false,
    },
  },
})

--##################
--## KEYBINDINGS ###
--##################
--
local mainMod = "SUPER"

hl.bind(mainMod .. " + SHIFT + q", hl.dsp.window.close())
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + b", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + c", hl.dsp.exec_cmd(calculator))
hl.bind(mainMod .. " + l", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + e", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + f", hl.dsp.window.fullscreen(""))
hl.bind(mainMod .. " + f", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + s", hl.dsp.layout("togglesplit"))
hl.bind("PRINT",
  hl.dsp.exec_cmd("grimblast -n -e 3000 -t png copysave screen -o " ..
    "$HOME" .. "/Pictures/Screenshot/$(date +'%Y-%m-%d-%H%M%S')_screenshot.png"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("grimblast -n -e 3000 -t png copy screen"))
hl.bind("SHIFT + PRINT",
  hl.dsp.exec_cmd("grimblast -n -e 3000 -t png copysave area -o " ..
    "$HOME" .. "/Pictures/Screenshot/$(date +'%Y-%m-%d-%H%M%S')_screenshot.png"))
hl.bind("CTRL + SHIFT + PRINT", hl.dsp.exec_cmd("grimblast -n -e 3000 -t png copy area"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1, silent = true }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2, silent = true }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3, silent = true }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4, silent = true }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5, silent = true }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6, silent = true }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7, silent = true }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8, silent = true }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9, silent = true }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10, silent = true }))

hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "d" }))

hl.bind("CTRL + ALT + right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("CTRL + ALT + left", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + ALT + left", hl.dsp.focus({ workspace = -1 }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volume down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volume mute"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--####################
--### WINDOW RULES ###
--####################

hl.window_rule({ match = { class = ".*", }, suppress_event = "maximize", })
hl.window_rule({ match = { class = "^$", title = "^$", xwayland = 1, fullscreen = 0, }, no_focus = true, })
hl.window_rule({ match = { class = "qalculate-gtk", }, float = true, })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol", title = "Volume Control", }, float = true, })
hl.window_rule({ match = { class = "nm-connection-editor", }, float = true, })
hl.window_rule({ match = { class = "Enpass", }, float = true, })
hl.window_rule({ match = { class = "xdg-desktop-portal-gtk", }, float = true, })
hl.window_rule({ match = { class = "thunar", title = "Rename", }, float = true, center = true, })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol", }, min_size = { 1024, 512 }, })
hl.window_rule({ match = { class = "Alacritty", }, opacity = "0.9", })
hl.window_rule({ match = { class = "thunar", }, opacity = "0.9", })
hl.window_rule({ match = { class = "tauonmb", }, opacity = "0.9", })
