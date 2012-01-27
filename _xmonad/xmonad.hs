-- Loki Davison's xmonad config
import XMonad
import XMonad.Actions.WindowBringer
import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops

main = xmonad $ ewmh defaultConfig
    { borderWidth        = 2
    , terminal           = "/usr/bin/urxvt -pe tabbed"
    , normalBorderColor  = "#000000"
    , focusedBorderColor = "#00bb00" }
	`additionalKeysP`
	[ ("M-g", gotoMenu)
    , ("M-b", bringMenu)
	]
	`additionalKeys`
	[ ((0, xK_Menu), spawn "easyxmotion.py --font '-monotype-arial-bold-r-normal--45-0-0-0-p-0-iso8859-15'")]
