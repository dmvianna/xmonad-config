{-# LANGUAGE OverloadedStrings #-}

import           System.IO
import           System.Process
import           System.Taffybar.Hooks.PagerHints (pagerHints)
import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Util.EZConfig             (additionalKeys)
import           XMonad.Util.Run                  (spawnPipe)

main = do
  xmonad . docks . pagerHints $ def
    { manageHook = manageDocks
                   <+> myManageHook
                   <+> manageHook defaultConfig
    , layoutHook = avoidStruts $ layoutHook defaultConfig
    , terminal = "urxvt"
    , normalBorderColor = "#cccccc"
    , focusedBorderColor = "#cd8b00"
    , modMask = mod4Mask -- depends on ~/.Xmodmap assigning Alt_R to mod3
    } `additionalKeys`
    [
    -- lock screen
    ((mod4Mask .|. shiftMask, xK_z), spawn "slimlock")

    -- Decrement brightness
    , ((0, xK_F1),
      spawn "light -U 5")

    -- Increment brightness
    , ((0, xK_F2),
    spawn "light -A 5")
    ]

myManageHook = composeOne
  [ className =? "wpa_gui" -?> doCenterFloat
  ]
