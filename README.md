<h1 align="center">dwm-arch</h1>

<p align="center">
  A keyboard-driven <b>dwm</b> desktop for <b>Arch Linux</b>, dynamically themed with Wallust.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/distro-Arch%20Linux-1793D1?style=flat-square" alt="Arch Linux">
  <img src="https://img.shields.io/badge/WM-dwm-000000?style=flat-square" alt="dwm">
</p>

This is my [dwm](https://dwm.suckless.org/) setup from Suckless, ported from my
[Ubuntu version](https://github.com/Ahmadalzin95/dwm-ubuntu-24-04) to Arch. One script
installs the window manager, the bar, dmenu and all the little helper tools I use day to day.
The whole look (dwm, dmenu, dunst and the terminal) is generated from the wallpaper with
[Wallust](https://codeberg.org/explosion-mental/wallust), so changing the background re-themes
the system.

> It works on my machines. No promises it works on yours.

## What's in it

* **One script to set it up.** `setup.sh` installs everything through `pacman`, pulls the few
  AUR packages with a plain `git clone` + `makepkg` (no yay/paru needed), and compiles dwm, dmenu
  and slstatus.
* **Dynamic colors.** Point Wallust at a wallpaper and dwm, dmenu, dunst and your terminal all
  follow the new palette.
* **A real status bar.** slstatus with WiFi, battery, temperature, Bluetooth and a clock. Hardware
  is detected automatically, so missing interfaces just disappear from the bar instead of showing junk.
* **System menu in dmenu.** WiFi, Bluetooth, VPN and power, all from one prompt (`Alt + s`).
* **Gaps**, keyboard-layout switching (US / DE / AR), screenshots, a blurred lockscreen and
  automatic multi-monitor profiles via autorandr.
* **Material-Black-Blueberry** GTK theme, macOS cursor and JetBrains Mono Nerd Font out of the box.

## Install

```bash
git clone https://github.com/Ahmadalzin95/dwm-arch.git ~/suckless
cd ~/suckless
chmod +x setup.sh
./setup.sh
```

The script links `~/.xinitrc` and installs a `dwm` session entry, so you can start it with
`startx` or pick **dwm** from your login manager.

## Scripts

Everything lives in [`scripts/`](scripts/):

| Script | What it does |
| ------ | ------------ |
| `apply-theme` | Set a wallpaper and regenerate the system colors with Wallust. |
| `dwm-menu` | The dmenu system menu: WiFi, Bluetooth, VPN, shutdown, reboot. |
| `app_manager` | List open windows in dmenu and kill the one you pick. |
| `hw_status` | Feeds slstatus the WiFi SSID/signal, battery, temperature. |
| `bt_status` | Bluetooth state for the bar. |
| `layout_toggle` | Cycle keyboard layout US → DE → AR with a notification. |
| `display-setup` | Open arandr to arrange monitors; autorandr saves the profile. |
| `screenshot` | Capture a selected area, the active window or the full screen. |
| `lock` | Blurred lockscreen via betterlockscreen / i3lock-color. |
| `mycal` | A small calendar popup. |
| `autostart.sh` | Startup bits (applies the saved monitor profile). |

## Shortcuts

`Alt` is the mod key; `Super` (Windows key) handles the system/hardware stuff.

**Apps & menus**

* `Alt + p` — app launcher (desktop apps)
* `Alt + Shift + p` — run command (dmenu_run)
* `Alt + Shift + Enter` — terminal (Alacritty)
* `Alt + s` — system menu
* `Alt + x` — app manager (kill windows)
* `Alt + F1` — calendar
* `Super + Shift + p` — image viewer (nsxiv)
* `Super + m` — monitor setup

**Windows**

* `Alt + j / k` — focus next / previous
* `Alt + Enter` — move window to master
* `Alt + Shift + c` — close window
* `Alt + h / l` — shrink / grow master
* `Alt + t / f / m` — tile / float / monocle layout
* `Alt + - / =` — shrink / grow gaps (`Alt + Shift + =` resets)
* `Alt + b` — toggle the bar
* `Alt + Ctrl + Shift + q` — restart dwm

**Hardware & media**

* `Super + Space` — switch keyboard layout (US → DE → AR)
* `Super + l` — lock screen
* `Print` — screenshot full screen
* `Super + s` — screenshot an area
* `Super + Shift + s` — screenshot the active window
* Volume and brightness keys work, with notifications
* Dunst: `Ctrl + Space` close · `Ctrl + Shift + Space` close all · `Ctrl + ~` history

## Theming

Change the whole look with one command:

```bash
apply-theme /path/to/wallpaper.jpg
```

## Notes

Based on sources from [suckless.org](https://suckless.org/). dwm and dmenu carry a few patches
for gaps, runtime colors from Xresources, status2d (colored bar text) and `.desktop` support in dmenu.
