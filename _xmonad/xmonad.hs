-- XMonad config, based on Noon Silk's: http://github.com/silky/dotfiles
-- This is a simple config with a focus on being able to switch between
-- layouts easily. Mostly through the use of easyxmotion. 
--
-- Author: Loki Davison
-- Location:  https://github.com/loki42
--
-- Inspiration:
-- http://www.haskell.org/haskellwiki/Xmonad/Config_archive/Brent_Yorgey%27s_Config.hs
-- http://www.haskell.org/wikiupload/9/9c/NNoeLLs_Desktop_2011-08-31.png
-- http://xmonad.org/xmonad-docs/xmonad/src/XMonad-Config.html
--
import System.IO
import XMonad hiding ( (|||) )
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
-- import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.OneBig
import XMonad.Layout.Mosaic
import XMonad.Layout.Grid
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Named(named)
import XMonad.Layout.ToggleLayouts
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Actions.WindowBringer
import XMonad.Actions.WindowGo
import XMonad.Actions.CopyWindow
import XMonad.Actions.UpdatePointer
import XMonad.Actions.CycleWS

import qualified XMonad.StackSet as W
import qualified Data.Map as M


-- Layout Management
--
-- We are interested in changing layouts in two ways. One is the
-- typical iteration with mod-space, the other is specific layout
-- selection through windows-<letter>, where the letter indicates
-- specific layout

myLayout = named "C:Tiled" tiled ||| named "C:MTiled" (Mirror tiled)
    ||| noBorders Full ||| named "C:Spiral" (spiral (3/4))
    ||| named "C:OneBig" (OneBig (3/4) (3/4)) ||| named "C:Grid" (GridRatio (16/10))
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled = Tall nmaster delta ratio
 
     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio = (2/(1 + (toRational(sqrt(5)::Double))))
 
     -- Percent of screen to increment by when resizing panes
     delta = 2/100

-- toggleLayouts is some function that takes two layouts,
-- it's sadly not a setting. Oh well. This config doesn't
-- toggle, but at least it's possible to change to specific
-- layouts.

myKeys = [
    -- mod4Mask is the windows key.
     ((mod4Mask, xK_f), sendMessage $ JumpToLayout "Full")
   , ((mod4Mask, xK_t), sendMessage $ JumpToLayout "C:Tiled")
   , ((mod4Mask, xK_w), sendMessage $ JumpToLayout "C:MTiled")
   , ((mod4Mask, xK_s), sendMessage $ JumpToLayout "C:Spiral")
   , ((mod4Mask, xK_b), sendMessage $ JumpToLayout "C:OneBig")
   , ((mod4Mask, xK_g), sendMessage $ JumpToLayout "C:Grid")


   -- The "Menu" key next to the Windows key, easy motion colour is currently lime green and needs old style fonts
   , ((0, xK_Menu), spawn "easyxmotion.py --colour='#0fff00' --font='-misc-fixed-bold-r-normal--45-0-100-100-c-0-iso8859-15'")

   --
   , ((mod4Mask, xK_q), spawn "kdesudo pm-suspend")
   , ((mod4Mask, xK_v), windows copyToAll)
   , ((mod4Mask .|. shiftMask, xK_v), killAllOtherCopies)

    -- Hmm
  ]


-- Toggle the active workspace with the 'Forward/Back' mouse buttons.
myMouseMod = 0
myMouseBindings x = M.fromList $
    [ ((myMouseMod, 8), (\w -> moveTo Prev NonEmptyWS)) -- prevWS))
    , ((myMouseMod, 9), (\w -> moveTo Next NonEmptyWS)) -- nextWS))
    ]


-- Setup
--
main = xmonad $ ewmh defaultConfig {
    borderWidth = 1
    , terminal = "/usr/bin/urxvt -pe tabbed"
    , normalBorderColor = "#000000"
    , focusedBorderColor = "#00bb00"
    , layoutHook = myLayout
    , mouseBindings = myMouseBindings

    -- Update pointer to be in the center on focus; I tried
    -- it being the 'Nearest' option, but this was not good
    -- because it still contains the bug wherein you shift
    -- to a new window and focus doesn't change.
    --
    , logHook = updatePointer (Relative 0.5 0.5)

} `additionalKeys` myKeys `additionalKeysP` [
      ("M-g", gotoMenu)
    , ("M-b", bringMenu)
    , ("M-0", spawn "notify-send \"`date '+%I:%M %b %d'`\"")
      -- Consider changing these to "Tab+", but it must be that it
      -- doesn't interrupt anything else.
      --
      -- Some default "goto" operations.
    , ("M-f", runOrRaise "firefox" (className =? "Firefox"))
    , ("M-v", runOrRaise "gvim" (className =? "Gvim"))
    ]
