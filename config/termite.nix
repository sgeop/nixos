{ pkgs, ... }:

let termiteConfig = pkgs.writeScript "termite-config" ''
  [colors]

  # special
  foreground      = #678aeb
  foreground_bold = #678aeb
  cursor          = #678aeb
  background      = rgba(0, 0, 0, 0.9)

  # # black
  # color0  = #1a1c1c
  # color8  = #e38ff2

  # # red
  # color1  = #222525
  # color9  = #8560f7

  # # green
  # color2  = #323636
  # color10 = #6441ca

  # # yellow
  # color3  = #484e4d
  # color11 = #5b57f9

  # # blue
  # color4  = #646b6a
  # color12 = #6adee8

  # # magenta
  # color5  = #858e8d
  # color13 = #5feaa1

  # # cyan
  # color6  = #abb7b6
  # color14 = #3152e0

  # # white
  # color7  = #d7e5e4
  # color15 = #5999f5
'';

in
  termiteConfig

