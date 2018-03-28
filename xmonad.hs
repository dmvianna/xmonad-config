{-# LANGUAGE OverloadedStrings #-}

import           System.IO
import           System.Process
import           System.Taffybar.Hooks.PagerHints (pagerHints)
import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Util.EZConfig             (additionalKeys,
                                                   additionalKeysP)
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
    } `additionalKeys` keyBindings
    `additionalKeysP` mediaKeys

keyBindings =
  [
    -- lock screen
    ((mod4Mask .|. shiftMask, xK_z), spawn "slimlock")
  ]

mediaKeys =
  [
    -- Decrement brightness
    ("<XF86MonBrightnessDown>",
      spawn "light -U 5")

    -- Increment brightness
  , ("<XF86MonBrightnessUp>",
     spawn "light -A 5")
  ]

myManageHook = composeOne
  [ className =? "wpa_gui" -?> doCenterFloat
  ]
