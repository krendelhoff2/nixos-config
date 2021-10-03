{-# LANGUAGE OverloadedStrings #-}

import Graphics.X11.Xlib
import System.Exit (exitSuccess)
import Data.Foldable (traverse_)

import qualified System.IO
import qualified Data.Map                        as M
import qualified XMonad.StackSet                 as W

import XMonad
import Data.Monoid
import Data.Foldable (traverse_)

import XMonad.Actions.CycleWS          (nextScreen, prevScreen)

import XMonad.Prompt ( XPConfig(font) )
import XMonad.Prompt.Pass
    ( passRemovePrompt, passGeneratePrompt, passPrompt )

import XMonad.Actions.MouseGestures ( Direction2D(U) )

import XMonad.Util.EZConfig ( additionalKeysP )
import XMonad.Util.Run                 (spawnPipe)
import XMonad.Util.Themes ( darkTheme, ThemeInfo(theme) )
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.WindowSwallowing

import XMonad.Layout.DecorationMadness ( shrinkText )
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders ( smartBorders )
import XMonad.Layout.Tabbed

import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.RefocusLast

import XMonad.Actions.DynamicProjects  (Project (..), dynamicProjects,
                                        switchProjectPrompt)
import Data.Ratio                      ((%))
import XMonad.Hooks.EwmhDesktops ( ewmh, ewmhFullscreen )
import XMonad.Hooks.ManageHelpers ( doCenterFloat )
import XMonad.Layout.Gaps ( gaps )
import XMonad.Layout.Spacing ( spacingWithEdge )

import XMonad.Util.SpawnOnce (spawnOnce)

import XMonad.Config.Xfce (xfceConfig)
import XMonad.Config.Kde (kde4Config)

myModMask :: KeyMask
myModMask = mod5Mask

myTerminal1 :: String
myTerminal1 = "cool-retro-term"

myTerminal :: String
myTerminal = "kitty"

appLauncher :: String
appLauncher = "rofi -theme theme -modi drun,ssh,window -show drun -show-icons"

screenshooter :: String
screenshooter = "(pidof xfce4-clipman || xfce4-clipman) & xfce4-screenshooter -r -c"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

keyboardLayoutToggle :: String
keyboardLayoutToggle = "layout-switch"

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth :: Dimension
myBorderWidth = 0

myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#1681f2"

myKeys conf@XConfig {XMonad.modMask = modm} = M.fromList $
  [ ((modm .|. shiftMask, xK_o), spawn $ XMonad.terminal conf)

  , ((modm , xK_y), spawn $ XMonad.terminal conf)

  , ((modm .|. shiftMask , xK_y), spawn $ myTerminal1)

  , ((modm,               xK_p     ), spawn appLauncher)

  , ((modm .|. shiftMask, xK_c     ), kill)

  , ((modm,               xK_space ), sendMessage NextLayout)

  , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

  , ((modm,               xK_n     ), refresh)

  , ((modm,               xK_t     ), spawn "toggle-sidebar")

  , ((modm .|. shiftMask,               xK_t     ), spawn "emacsclient -c -e '(telega)'")

  , ((controlMask, xK_backslash), spawn keyboardLayoutToggle)

  --, ((controlMask, xK_apostrophe), spawn "setxkbmap us")

  , ((modm,               xK_c     ), spawn "/home/savely/.emacs.d/bin/org-capture")

  , ((modm .|. shiftMask, xK_x     ), spawn "systemctl --user restart emacs.service")

  , ((modm,               xK_Tab   ), windows W.focusDown)

  , ((modm,               xK_j     ), windows W.focusDown)

  , ((modm .|. shiftMask, xK_p     ), spawn screenshooter)

  , ((modm,               xK_k     ), windows W.focusUp  )

  , ((modm,               xK_m     ), windows W.focusMaster  )

  , ((modm,               xK_Return), windows W.swapMaster)

  , ((modm, xK_x), spawn "powermenu")

  , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

  , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

  , ((modm, xK_u     ), spawn "emacsclient -c"  )

  , ((modm,               xK_a), sendMessage MirrorShrink)

  , ((modm,               xK_z), sendMessage MirrorExpand)

  , ((modm,               xK_h     ), sendMessage Shrink)

  , ((modm,               xK_l     ), sendMessage Expand)

  , ((modm .|. shiftMask,               xK_f     ), withFocused $ windows . W.sink)

  , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

  , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

  --, ((modm              , xK_b     ), sendMessage ToggleStruts)

  , ((modm .|. shiftMask, xK_q     ), io exitSuccess)

  , ((modm, xK_F1     ), spawn "amixer -q set Master toggle")
  , ((modm, xK_F4     ), spawn "amixer -q set Master 5%-")
  , ((modm, xK_F5     ), spawn "amixer -q set Master 5%+")

  , ((modm              , xK_q     ), spawn "xmonad --restart")
  , ((modm , xK_f)                              , passPrompt promptConfig)
  , ((modm .|. controlMask, xK_f)               , passGeneratePrompt promptConfig)
  , ((modm .|. controlMask  .|. shiftMask, xK_f), passRemovePrompt promptConfig)
  ]
  ++
  [((m .|. modm, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++

  [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_e, xK_w, xK_r] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

promptConfig :: XPConfig
promptConfig = def { font = "xft:Hurmit Nerd Font Mono:pixelsize=15" }

myMouseBindings XConfig {XMonad.modMask = modm} = M.fromList
  [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                    >> windows W.shiftMaster)

  , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

  , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                    >> windows W.shiftMaster)
  ]

myWorkspaces :: [String]
myWorkspaces = show <$> [1..10]

myLayoutHook = avoidStruts
             $ spacingWithEdge 3
             $ gaps [(U,15)]
             -- $ toggleLayouts (noBorders Full)
             $ smartBorders
             $ tiled ||| Mirror tiled ||| tabbed shrinkText ((theme darkTheme) { decoHeight = 0 })
  where
    tiled = ResizableTall nmaster delta ratio []
    nmaster = 1
    delta   = 3/100
    ratio   = 1/2

-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.

myManageHook :: Query (Endo WindowSet)
myManageHook = composeAll
  [ className =? "pinentry"         --> doFloat
  , className =? "xmessage"         --> doFloat
  , className =? ".xscreensaver-demo-wrapped" --> doFloat
  , className =? "Minecraft* 1.18.2" --> doShift "6"
  , className =? "cpw-mods-bootstraplauncher-BootstrapLauncher" --> doFloat
  , className =? "explorer.exe" --> doFloat
  , className =? "desktop-launcher" --> doFloat
  , resource  =? "desktop_window"   --> doIgnore
  , resource  =? "kdesktop"         --> doIgnore
  , title     =? "Media viewer"     --> doCenterFloat
  , title     =? "doom-capture"     --> doCenterFloat
  , manageDocks
  ]

myHandleEventHook :: Event -> X All
myHandleEventHook = swallowEventHook (className =? "kitty" <||> className =? "XTerm") (return True)

myLogHook :: X ()
myLogHook = return ()

myStartupHook :: X ()
myStartupHook = traverse_ (spawnOnce . (<> " &"))
  [
  ]

main = xmonad $ withSB mySB
              $ ewmh
              $ ewmhFullscreen
              $ dynamicProjects projects
              $ docks
              $ mkDefaults def

mkDefaults defaults = defaults
  { terminal          = myTerminal
  , keys              = myKeys
  , mouseBindings     = myMouseBindings
  , focusFollowsMouse = myFocusFollowsMouse
  , clickJustFocuses  = myClickJustFocuses
  , borderWidth       = myBorderWidth
  , modMask           = myModMask
  , workspaces        = myWorkspaces
  , layoutHook        = myLayoutHook
  , manageHook        = manageHook defaults <+> myManageHook
  , handleEventHook   = myHandleEventHook <+> handleEventHook defaults
  , startupHook       = startupHook defaults <+> myStartupHook
  , logHook           = logHook defaults
  }

projects :: [Project]
projects = []

mySB :: StatusBarConfig
mySB = statusBarProp "eww --config ~/.config/eww/arin daemon && launch-bar" def
