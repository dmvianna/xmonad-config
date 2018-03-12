{-# LANGUAGE OverloadedStrings #-}

-- import qualified Data.Text                        as T
import           System.IO
import           System.Process
import           System.Taffybar.Hooks.PagerHints (pagerHints)
-- import qualified Turtle                           as Turtle
import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Util.EZConfig             (additionalKeys)
import           XMonad.Util.Run                  (spawnPipe)


-- conditionalPipe :: T.Text -> T.Text -> Handle
-- conditionalPipe p args =
--   case Turtle.proc "pgrep" ["-x", p] 0 of
--     Turtle.ExitFailure _ ->
--       spawnPipe $ T.pack (T.concat [p " " args])
--     Turtle.ExitSuccess   -> pure mempty

main = do
  _ <- spawnPipe "xautolock -time 10 -locker slock"
  _ <- spawnPipe "taffybar"
  _ <- spawnPipe "wpa_gui -t"
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
    ((mod4Mask .|. shiftMask, xK_z), spawn "xautolock -locknow")

    -- Decrement brightness
    , ((0, xK_F1),
      spawn "/var/setuid-wrappers/light -U 5")

    -- Increment brightness
    , ((0, xK_F2),
    spawn "/var/setuid-wrappers/light -A 5")
    ]

myManageHook = composeOne
  [ className =? "wpa_gui" -?> doCenterFloat
  ]
