-- Loki Davison's xmonad config
import XMonad

main = xmonad $ defaultConfig
    { borderWidth        = 1
    , terminal           = "/usr/bin/konsole"
    , normalBorderColor  = "#000000"
    , focusedBorderColor = "#cd8b00" }
