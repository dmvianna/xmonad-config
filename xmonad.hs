
import           System.IO
import           System.Process
import           System.Taffybar.Hooks.PagerHints (pagerHints)
import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Util.EZConfig             (additionalKeys)
import           XMonad.Util.Run                  (spawnPipe)



main = do
  _ <- spawnPipe "xautolock -time 10 -locker slock"
  _ <- spawnPipe "taffybar"
  -- _ <- case readProcess "pgrep" ["-x"] "wpa_gui" of
  --       Nothing -> spawnPipe "wpa_gui -t"
  --       _ -> mempty
  xmonad . docks . pagerHints $ def
    { manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = avoidStruts $ layoutHook defaultConfig
    , terminal = "urxvt"
    , normalBorderColor = "#cccccc"
    , focusedBorderColor = "#cd8b00"
    , modMask = mod4Mask -- depends on ~/.Xmodmap assigning Alt_R to mod3
    } `additionalKeys`
    [
    -- lock screen
    ((mod4Mask .|. shiftMask, xK_z), spawn "xautolock -locknow")

    -- Decrement brightness
    , ((0, xK_F1),
      spawn "/var/setuid-wrappers/light -U 5")

    -- Increment brightness
    , ((0, xK_F2),
    spawn "/var/setuid-wrappers/light -A 5")
    ]
