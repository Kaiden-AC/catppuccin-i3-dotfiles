; ~/.config/polybar/config.ini

[settings]
screenchange-reload = true
;compositing-background = source
;compositing-foreground = over
;compositing-overline = over
;compositing-underline = over
;compositing-border = over

pseudo-transparency = true

; Define fallback values used by all module formats
; format-foreground = #FF0000
; format-background = #00FF00
; format-underline =
; format-overline =
; format-spacing =
; format-padding =
; format-margin =
; format-offset =

[global/wm]
margin-top = 0
margin-bottom = 0

;==========================================================
; Catppuccin Mocha Colors
;==========================================================
[color]
background = #1e1e2e
background-alt = #181825
foreground = #cdd6f4
foreground-alt = #a6adc8
primary = #89b4fa
secondary = #f5c2e7
alert = #f38ba8
disabled = #6c7086

rosewater = #f5e0dc
flamingo = #f2cdcd
pink = #f5c2e7
mauve = #cba6f7
red = #f38ba8
maroon = #eba0ac
peach = #fab387
yellow = #f9e2af
green = #a6e3a1
teal = #94e2d5
sky = #89dceb
sapphire = #74c7ec
blue = #89b4fa
lavender = #b4befe
text = #cdd6f4
subtext1 = #bac2de
subtext0 = #a6adc8
overlay2 = #9399b2
overlay1 = #7f849c
overlay0 = #6c7086
surface2 = #585b70
surface1 = #45475a
surface0 = #313244
base = #1e1e2e
mantle = #181825
crust = #11111b

;==========================================================
; Bar Settings
;==========================================================
[bar/main]
width = 100%
height = 28
; offset-x = 1%
; offset-y = 1%
radius = 6.0
fixed-center = true

background = ${color.background}
foreground = ${color.foreground}

line-size = 2
line-color = ${color.primary}

border-size = 4
border-color = ${color.background}

padding-left = 1
padding-right = 1

module-margin-left = 1
module-margin-right = 1

; Fonts - Specify fallback fonts if needed
font-0 = "JetBrainsMono Nerd Font:style=Medium:size=10;2"
font-1 = "JetBrainsMono Nerd Font:style=Bold:size=10;2"
font-2 = "JetBrainsMono Nerd Font:style=Italic:size=10;2"
font-3 = "Noto Sans Symbols2:style=Regular:pixelsize=10;3" ; For extra symbols if needed

modules-left = i3 xwindow
modules-center = date
modules-right = filesystem pulseaudio memory cpu network battery temperature powermenu

tray-position = right
tray-padding = 2
; tray-background = ${color.background-alt}
; tray-transparent = true
; tray-maxsize = 16

cursor-click = pointer
cursor-scroll = ns-resize

enable-ipc = true

; wm-restack = bspwm
wm-restack = i3
override-redirect = false

;==========================================================
; Modules
;==========================================================

[module/i3]
type = internal/i3
format = <label-state> <label-mode>
index-sort = true
wrapping-scroll = false
strip-wsnumbers = true ; Remove numbers if using names like "1 <icon>"

; Use fuzzy matching for workspace names
ws-icon-0 = 1;󰈹
ws-icon-1 = 2;
ws-icon-2 = 3;󰨞
ws-icon-3 = 4;󰙯
ws-icon-4 = 5;󰓇
ws-icon-5 = 6;󰭻
ws-icon-6 = 7;7
ws-icon-7 = 8;8
ws-icon-8 = 9;9
ws-icon-9 = 10;10
ws-icon-default = 󰘣

label-mode-padding = 1
label-mode-foreground = ${color.foreground}
label-mode-background = ${color.background-alt}

; Focused workspace
label-focused = %icon%
label-focused-foreground = ${color.background}
label-focused-background = ${color.primary}
label-focused-underline = ${color.primary}
label-focused-padding = 1

; Unfocused workspace
label-unfocused = %icon%
label-unfocused-foreground = ${color.foreground-alt}
label-unfocused-padding = 1

; Visible workspace (on another monitor)
label-visible = %icon%
label-visible-underline = ${color.secondary}
label-visible-padding = 1

; Urgent workspace
label-urgent = %icon%
label-urgent-foreground = ${color.background}
label-urgent-background = ${color.alert}
label-urgent-padding = 1

; Separator between workspaces
; label-separator = |
; label-separator-foreground = ${color.disabled}


[module/xwindow]
type = internal/xwindow
label = %title:0:60:...%
label-foreground = ${color.foreground}


[module/filesystem]
type = internal/fs
interval = 25
mount-0 = /

label-mounted =  %{F#${color.peach}}%mountpoint%%{F-}: %free%
label-unmounted = %mountpoint% not mounted
label-unmounted-foreground = ${color.disabled}


[module/pulseaudio]
type = internal/pulseaudio
use-ui-max = false ; Show volume above 100% if applicable
interval = 5
format-volume = <ramp-volume> <label-volume>
format-muted = <label-muted>
label-volume = %percentage%%
label-muted = 󰖁 Muted
label-muted-foreground = ${color.disabled}

ramp-volume-0 = 󰕿
ramp-volume-1 = 󰖀
ramp-volume-2 = 󰖀
ramp-volume-3 = 󰖀
ramp-volume-4 = 󰖀
ramp-volume-5 = 󰖀
ramp-volume-6 = 󰖀
ramp-volume-7 = 󰖀
ramp-volume-8 = 󰖀
ramp-volume-9 = 󰕾
ramp-volume-foreground = ${color.mauve}

; Increase volume scroll step if needed
; click-right = pavucontrol


[module/memory]
type = internal/memory
interval = 2
format-prefix = "󰍛 "
format-prefix-foreground = ${color.green}
label = %percentage_used%%


[module/cpu]
type = internal/cpu
interval = 2
format-prefix = "󰻠 "
format-prefix-foreground = ${color.red}
label = %percentage:2%%


[module/date]
type = internal/date
interval = 1.0

time = %I:%M %p
time-alt = %Y-%m-%d %H:%M:%S
format = <label>
format-prefix = "󰃭 "
format-prefix-foreground = ${color.yellow}
label = %time%


[module/network]
type = internal/network
interface = wlan0 # Check your interface name with `ip link`
interface-type = wireless
interval = 3.0

format-connected = <ramp-signal> <label-connected>
format-disconnected = <label-disconnected>

label-connected = %essid% (%local_ip%)
label-connected-foreground = ${color.sky}
label-disconnected = 󰖪 Disconnected
label-disconnected-foreground = ${color.disabled}

ramp-signal-0 = 󰖩
ramp-signal-1 = 󰖩
ramp-signal-2 = 󰖩
ramp-signal-3 = 󰖩
ramp-signal-4 = 󰖩
ramp-signal-5 = 󰖩
ramp-signal-foreground = ${color.sky}


[module/battery]
type = internal/battery
full-at = 99
battery = BAT0 # Check your battery name with `ls /sys/class/power_supply/`
adapter = ACAD # Check your adapter name
poll-interval = 5

format-charging = <animation-charging> <label-charging>
format-discharging = <ramp-capacity> <label-discharging>
format-full = <label-full>

label-charging = %percentage%%
label-discharging = %percentage%%
label-full = 󰁹 Full

ramp-capacity-0 = 󰁺
ramp-capacity-1 = 󰁻
ramp-capacity-2 = 󰁼
ramp-capacity-3 = 󰁽
ramp-capacity-4 = 󰁾
ramp-capacity-5 = 󰁿
ramp-capacity-6 = 󰂀
ramp-capacity-7 = 󰂁
ramp-capacity-8 = 󰂂
ramp-capacity-9 = 󰁹
ramp-capacity-foreground = ${color.green}

animation-charging-0 = 󰢜
animation-charging-1 = 󰂆
animation-charging-2 = 󰂇
animation-charging-3 = 󰂈
animation-charging-4 = 󰢝
animation-charging-5 = 󰂉
animation-charging-6 = 󰢞
animation-charging-7 = 󰂊
animation-charging-8 = 󰂋
animation-charging-9 = 󰂅
animation-charging-framerate = 750
animation-charging-foreground = ${color.yellow}


[module/temperature]
type = internal/temperature
thermal-zone = 0 # Check your zone with `ls /sys/class/thermal/`
warn-temperature = 70
interval = 5

format = <ramp> <label>
format-warn = <ramp> <label-warn>
format-prefix = "󰔏 "
format-prefix-foreground = ${color.flamingo}

label = %temperature-c%°C
label-warn = %temperature-c%°C
label-warn-foreground = ${color.red}

ramp-0 = 󰔏
ramp-1 = 󰔏
ramp-2 = 󰔏
ramp-foreground = ${color.peach}


[module/powermenu]
type = custom/text
content = 󰐥
content-padding = 1
content-background = ${color.background}
content-foreground = ${color.red}
; click-left = ~/.config/rofi/powermenu/powermenu.sh
click-left = rofi -show power-menu -modi power-menu:~/.config/rofi/scripts/rofi-power-menu -theme ~/.config/rofi/powermenu/style.rasi


;==========================================================
; Other Settings
;==========================================================

[module/sep]
type = custom/text
content = "|"
content-foreground = ${color.disabled}

; vim:ft=dosini
