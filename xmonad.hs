-- Author: Wasif Malik (wmalik@gmail.com)

-- Imports
import XMonad
-- Prompt
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)
-- Hooks
import XMonad.Operations
import System.IO
import System.Exit
import XMonad.Util.Run
import XMonad.Util.Paste
import XMonad.Util.Loggers
import XMonad.Actions.CycleWS
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IM
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid
import XMonad.Layout.ShowWName
-- for chrome full screen
import XMonad.Hooks.EwmhDesktops
import Graphics.X11.ExtraTypes.XF86
import Data.Ratio ((%))
import qualified XMonad.StackSet as W
import qualified Data.Map as M

import XMonad.Actions.UpdatePointer

-- Config
-- Define Terminal
-- Define modMask
modMask' :: KeyMask
modMask' = mod4Mask
-- Define workspaces
myWorkspaces    = ["1","2","3","4","5", "6", "7", "8", "9", "10"]
myXmonadBar = "killall dzen2; dzen2 -ta 'l' -tw 600 -e"
myStatusBar = "killall conky; conky -c ~/.xmonad/.conky_dzen | dzen2 -xs 2 -ta 'r' -e"
myBitmapsDir = ".xmonad/bitmaps/"
--
-- Main
main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    -- midTrayer <- spawnPipe myTrayer
    xmonad $ withUrgencyHookC dzenUrgencyHook { args = ["-bg", "red", "fg", "black", "-y", "25"] } urgencyConfig { remindWhen = Every 15 } $ defaultConfig
      { workspaces          = myWorkspaces
      , keys                = keys'
      , startupHook         = setWMName "LG3D"
      , modMask             = modMask'
      , layoutHook          = customLayout
      , manageHook          = manageHook'
      , logHook             = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd >> updatePointer (0.95, 0.95) (0, 0)
      , normalBorderColor   = colorNormalBorder
      , focusedBorderColor  = colorFocusedBorder
      , borderWidth         = 1
      , handleEventHook     = fullscreenEventHook --for chrome full screen-- {{{-- }}}
      {-, startupHook         = spawn "~/.xmonad/scripts/on-start.sh"-}
      , terminal            = "urxvt"
      , focusFollowsMouse   = False
      , mouseBindings   = myMouseBindings
}
--}}}

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((0, 8), (\w -> windows W.focusDown)) -- useful when cycling through windows in a full screen layout
    , ((0, 9), (\w -> toggleWS)) -- cycle between current and last used workspace
    , ((0, 6), (\w -> spawn "notify-send -t 5000 \"`/usr/bin/yubioath || echo 'No yubikey?'`\""))
    , ((0, 7), (\w -> spawn "notify-send -t 5000 \"`curl ipinfo.io/ip || echo 'Got net?'`\""))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-- Hooks {{{
-- ManageHook {{{
manageHook' :: ManageHook
manageHook' = (composeAll . concat $
    [ [resource     =? r            --> doIgnore            |   r   <- myIgnores] -- ignore desktop
    , [className    =? c            --> doShift  "1"   |   c   <- myDev    ] -- move dev to main
    , [className    =? c            --> doShift  "2"    |   c   <- myWebs   ] -- move webs to main
    , [className    =? c            --> doShift  "3"    |   c   <- myVim    ] -- move vim to vim
    , [className    =? c            --> doShift	 "4"   |   c   <- myPidgin  ]
    , [className    =? c            --> doShift	 "9"   |   c   <- myToys  ]
    , [className    =? c            --> doCenterFloat       |   c   <- myFloats ] -- float my floats
    , [name         =? n            --> doCenterFloat       |   n   <- myNames  ] -- float my names
    , [isFullscreen                 --> myDoFullFloat                           ]
    , [manageDocks]
    ])

    where

        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"

        -- classnames
        myWebs    = ["Firefox", "Firefox-esr", "Google-chrome","Chromium", "Chromium-browser","Iceweasel","iceweasel"]
        myPidgin  = ["Pidgin","Buddy List", "chat", "Slack", "Skype", "skype"]
        myDev	  = ["urxvt"]
        myVim	  = ["Gvim"]
        myToys	  = ["Conky"]

        -- resources
        -- xprop | grep WM_CLASS
        myFloats  = ["notify-osd","Xmessage","XFontSel","Downloads","bashrun"]
        myIgnores = ["xfce4-notifyd","stalonetray","trayer","panel"]

        -- names
        myNames   = ["Google Chrome Options","Chromium Options"]

-- a trick for fullscreen but stil allow focusing of other WSs
myDoFullFloat :: ManageHook
myDoFullFloat = doF W.focusDown <+> doFullFloat
-- }}}
-- layoutHook'  =  onWorkspaces ["4"] gridLayout $
--                 fullScreenLayout

--Bar
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor "white" "ForestGreen" . pad
      , ppVisible           =   dzenColor "white" "blue" . pad
      , ppHidden            =   dzenColor "white" "black" . pad
      , ppHiddenNoWindows   =   dzenColor "#3D3D3D" "black" . pad
      , ppUrgent            =   dzenColor "black" "red" . pad
      , ppWsSep             =   " "
      , ppSep               =   " | "
      {-, ppExtras = [wrapL "[" "]" $ date "%a %d %b"]-}
      {-, ppExtras = [wrapL "[" "]" $ dzenColorL "green" "#2A4C3F" (logCmd "wget http://ipinfo.io/ip -qO -")]-}
      , ppLayout            =   dzenColor "#ebac54" "black" .
                                (\x -> case x of
                                    "Spacing 3 Tall"         -> "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Mirror Spacing 3 Tall"  -> "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Full"                   -> "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    _                        -> x
                                )
      , ppTitle             =   dzenColor "black" "gray" . dzenEscape . (" "++) . (++" ")
      , ppOutput            =   hPutStrLn h
    }

-- Layout

customLayout = avoidStruts $ tiled1 ||| Mirror tiled1 ||| Full
   where
     tiled1 = spacing 3 $ Tall 1 (2/100) (1/2)

--}}}
-- Theme {{{
-- Color names are easier to remember:
colorBlack          = "#000000"
colorOrange         = "#FD971F"
colorDarkGray       = "#1B1D1E"
colorPink           = "#F92672"
colorGreen          = "#A6E22E"
colorBlue           = "#66D9EF"
colorYellow         = "#E6DB74"
colorWhite          = "#CCCCC6"

colorNormalBorder   = "black"
colorFocusedBorder  = "white"


barFont  = "inconsolata"
barXFont = "inconsolata:size=14"
xftFont = "xft: inconsolata-14"
--}}}

-- Prompt Config {{{
mXPConfig :: XPConfig
mXPConfig =
    defaultXPConfig { font                  = barFont
                    , bgColor               = colorBlack
                    , fgColor               = colorYellow
                    , bgHLight              = colorGreen
                    , fgHLight              = colorDarkGray
                    , promptBorderWidth     = 1
                    , height                = 16
                    , historyFilter         = deleteConsecutive
                    }

-- Run or Raise Menu
largeXPConfig :: XPConfig
largeXPConfig = mXPConfig
                { font = xftFont
                , height = 35
                }
-- }}}
-- Key mapping {{{
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [
      ((modMask,                    xK_p     ), runOrRaisePrompt largeXPConfig)
    , ((modMask .|. shiftMask,      xK_Return), spawn $ XMonad.terminal conf)
    , ((modMask,                    xK_d     ), kill)
    , ((modMask .|. shiftMask,      xK_c     ), kill)
    , ((0,                          xK_Insert), pasteSelection)
    , ((modMask,                    xK_Tab     ), toggleWS)
    , ((modMask,                    xK_n     ), spawn "urxvt -e wicd-curses")
    , ((modMask,                    xK_v     ), spawn "urxvt -e bash -c 'echo $HOSTNAME'")

    -- Programs
    , ((modMask,                    xK_Print ), spawn "cd ~/screenshots; scrot -e 'notify-send -t 2000 $f --icon=/home/arthur/screenshots/$f'")
    , ((modMask .|. shiftMask,      xK_Print ), spawn "cd ~/screenshots; scrot -u -e 'notify-send -t 2000 $f --icon=/home/arthur/screenshots/$f'")
    , ((modMask,		            xK_o     ), spawn "firefox")
    , ((modMask .|. shiftMask,		xK_o     ), spawn "firefox --private-window")
    , ((modMask,		            xK_s     ), spawn "keepass2")
    , ((modMask,		            xK_y     ), spawn "pkill -9 yubioath-gui; yubioath-gui")
    , ((modMask .|. shiftMask,	    xK_l     ), spawn "xscreensaver-command -lock")

    -- Media Keys
    , ((0,                          xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5")
    , ((0,                          xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 5")
    , ((0,                          xF86XK_AudioMute        ), spawn "amixer -q sset Master toggle")  -- XF86AudioMute
    , ((0,                          xF86XK_AudioLowerVolume ), spawn "amixer -q sset Master 5%-; notify-send -t 100 `amixer get Master | egrep -o \"[0-9]+%\"` ") -- XF86AudioLowerVolume
    , ((0,                          xF86XK_AudioRaiseVolume ), spawn "amixer -q sset Master 5%+; notify-send -t 100 `amixer get Master | egrep -o \"[0-9]+%\"`")  -- XF86AudioRaiseVolume.
    , ((modMask,                    xK_Down                 ), spawn "amixer -q sset Master 5%-")
    , ((modMask,                    xK_Up                   ), spawn "amixer -q sset Master 5%+")

    -- layouts
    , ((modMask,                    xK_space ), sendMessage NextLayout)
    , ((modMask .|. shiftMask,      xK_space ), setLayout $ XMonad.layoutHook conf)          -- reset layout on current desktop to default
    , ((modMask,                    xK_b     ), sendMessage ToggleStruts)
    -- , ((modMask,                    xK_n     ), refresh)
    , ((modMask,                    xK_z     ), windows W.focusDown)
    , ((modMask,                    xK_j     ), windows W.focusDown)
    , ((modMask,                    xK_k     ), windows W.focusUp  )
    , ((modMask .|. shiftMask,      xK_j     ), windows W.swapDown)                          -- swap the focused window with the next window
    , ((modMask .|. shiftMask,      xK_k     ), windows W.swapUp)                            -- swap the focused window with the previous window
    , ((modMask,                    xK_Return), windows W.swapMaster)
    , ((modMask,                    xK_t     ), withFocused $ windows . W.sink)              -- Push window back into tiling
    , ((modMask,                    xK_h     ), sendMessage Shrink)                          -- %! Shrink a master area
    , ((modMask,                    xK_l     ), sendMessage Expand)                          -- %! Expand a master area
    , ((modMask,                    xK_comma ), sendMessage (IncMasterN 1))                  -- Increment the number of windows in the master area
    , ((modMask,                    xK_period), sendMessage (IncMasterN (-1)))               -- Deincrement the number of windows in the master area

    --Urgency hooks
    , ((modMask,                    xK_BackSpace), focusUrgent)

    -- workspaces
    , ((modMask .|. controlMask,   xK_Right), nextWS)
    , ((modMask .|. shiftMask,     xK_Right), shiftToNext)
    , ((modMask .|. controlMask,   xK_Left ), prevWS)
    , ((modMask .|. shiftMask,     xK_Left ), shiftToPrev)

    -- quit, or restart
    , ((modMask,                   xK_c    ), spawn "killall -SIGUSR1 conky")
    , ((modMask,                   xK_x    ), spawn "killall conky; conky -c ~/.xmonad/.conky_dzen | dzen2 -xs 2 -ta 'r' -e 'onstart=lower'")
    , ((modMask,                   xK_F1   ), spawn "~/.screenlayout/laptop.sh")
    , ((modMask,                   xK_F2   ), spawn "~/.screenlayout/work.sh")
    , ((modMask,                   xK_F3   ), spawn "~/.screenlayout/work_mirror.sh")
    , ((modMask,                   xK_F12  ), spawn "sudo pm-suspend-hybrid")
    , ((modMask,                   xK_r    ), spawn "/usr/bin/xmonad --recompile && /usr/bin/xmonad --restart")
    , ((modMask,               xK_Down),  nextWS)
    , ((modMask,               xK_Up),    prevWS)
    , ((modMask .|. shiftMask, xK_Down),  shiftToNext)
    , ((modMask .|. shiftMask, xK_Up),    shiftToPrev)
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e] [1, 0]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

