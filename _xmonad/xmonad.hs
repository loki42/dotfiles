-- Loki Davison's xmonad config
import XMonad
import XMonad.Actions.WindowBringer
import XMonad.Util.EZConfig

main = xmonad $ defaultConfig
    { borderWidth        = 1
    , terminal           = "/usr/bin/urxvt -pe tabbed"
    , normalBorderColor  = "#000000"
    , focusedBorderColor = "#00bb00" }
	`additionalKeysP`
	[ ("M-g", gotoMenu)
    , ("M-b", bringMenu)
	]
