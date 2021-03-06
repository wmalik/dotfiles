-- Author: Wasif Malik (wmalik@gmail.com)

-- Imports
import XMonad hiding ( (|||) )
-- Prompt
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)
import XMonad.Prompt.Window
-- Hooks
import XMonad.Operations
import System.IO
import System.Exit
import XMonad.Util.Run
import XMonad.Util.Paste
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
import XMonad.Layout hiding ( (|||) )
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.IM
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid
import XMonad.Layout.ShowWName
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.StackTile
import XMonad.Layout.Cross
import XMonad.Layout.DecorationMadness
-- for chrome full screen
import Graphics.X11.ExtraTypes.XF86
import Data.Ratio ((%))
import qualified XMonad.StackSet as W
import qualified Data.Map as M

import XMonad.Actions.SimpleDate

import XMonad.Actions.UpdatePointer
import XMonad.Config.Desktop
import XMonad.Config.Gnome

import XMonad.Util.Themes


-- Config
-- Define Terminal
-- Define modMask
modMask' :: KeyMask
modMask' = mod4Mask
-- Define workspaces
myWorkspaces    = ["1","2","3","4","5", "6", "7", "8", "9", "10"]
myXmonadBar = "killall dzen2; dzen2 -dock -ta 'l' -tw 600 -e"
myStatusBar = "conky -c ~/.xmonad/conky_dzen | dzen2 -dock -xs 2 -ta 'r' -e"
bottomStatusBar = "conky -c ~/.xmonad/conky_dzen_bottom | dzen2 -x '0' -y '10000' -h '15'  -ta 'r' -dock"

myBitmapsDir = ".xmonad/bitmaps/"
--
-- Main
main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    dzenBottomBar <- spawnPipe bottomStatusBar
    xmonad $ ewmh $ withUrgencyHookC dzenUrgencyHook { args = ["-bg", "red", "fg", "black", "-y", "25"] } urgencyConfig { remindWhen = Every 15 } $ docks $ desktopConfig
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
      --for chrome full screen-- {{{-- }}}
      , handleEventHook     = fullscreenEventHook  -- mayve bring back the ewmh handle hook to fix dunst focus?
      {-, startupHook         = spawn "~/.xmonad/scripts/on-start.sh"-}
      , terminal            = "urxvt"
      , focusFollowsMouse   = False
      , mouseBindings   = myMouseBindings
}
--}}}

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((0, 8), (\w -> windows W.focusDown)) -- useful when cycling through windows in a full screen layout
    , ((0, 9), (\w -> toggleWS)) -- cycle between current and last used workspace
    {- , ((0, 7), (\w -> spawn "amixer -q sset Master 5%-; notify-send -t 1000 `amixer get Master | egrep -o \"[0-9]+%\"` ")) -}
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
    ++
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)) -- mod-button1, Set the window to floating mode and move by dragging
    , ((modMask, button2), (\w -> focus w >> windows W.shiftMaster)) -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)) -- mod-button3, Set the window to floating mode and resize by dragging
    , ((0, 9), (\w -> toggleWS)) -- cycle between current and last used workspace
    ]

-- Hooks {{{
-- ManageHook {{{
manageHook' :: ManageHook
manageHook' = (composeAll . concat $
    [ [resource     =? r            --> doIgnore            |   r   <- myIgnores] -- ignore desktop
    , [className    =? c            --> doShift  "1"   |   c   <- myDev    ] -- move dev to main
    , [className    =? c            --> doShift  "2"    |   c   <- myWebs   ] -- move webs to main
    , [className    =? c            --> doShift  "4"   |   c   <- myChat  ]
    , [className    =? c            --> doShift  "9"   |   c   <- myToys  ]
    , [className    =? c            --> doCenterFloat       |   c   <- myFloats ] -- float my floats
    , [name         =? n            --> doCenterFloat       |   n   <- myNames  ] -- float my names
    --, [isFullscreen                 --> myDoFullFloat                           ]
    , [manageDocks]
    ])

    where
        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"

        -- classnames
        -- xprop | grep WM_CLASS
        myWebs    = ["Nightly", "Firefox", "Firefox-esr", "Google-chrome","Chromium", "Chromium-browser","Iceweasel","iceweasel"]
        myChat  = ["Pidgin","Buddy List", "chat", "Slack", "Skype", "skype"]
        myDev   = ["urxvt"]
        myToys  = ["Conky"]

        -- resources
        myFloats  = ["vokoscreen","ffplay","notify-osd","Xmessage","XFontSel","Downloads","bashrun"]
        myIgnores = ["xfce4-notifyd","stalonetray","trayer","panel", "desktop","desktop_window","notify-osd", "Toplevel"]

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
      , ppSep               =   " "
      , ppLayout            =   dzenColor "#ebac54" "black"
      , ppTitle             =   dzenColor "white" "black"
      , ppOutput            =   hPutStrLn h
    }

-- Layout

tiled = Tall 1 (2/100) (1/2)
customLayout = avoidStruts $ smartBorders(
                                          tiled
                                      ||| Mirror tiled
                                      ||| Accordion
                                      ||| tabbedBottom shrinkText (theme donaldTheme)
                             )

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
colorPurple         = "#8F00FF"

colorNormalBorder   = "black"
colorFocusedBorder  = colorPurple


barFont  = "inconsolata"
barXFont = "inconsolata:size=14"
xftFont = "xft: inconsolata-18"
--}}}

-- Prompt Config {{{
mXPConfig :: XPConfig
mXPConfig =
    defaultXPConfig { font                  = barFont
                    , bgColor               = colorPurple
                    , fgColor               = colorWhite
                    , bgHLight              = colorGreen
                    , fgHLight              = colorDarkGray
                    , promptBorderWidth     = 0
                    , height                = 16
                    , historyFilter         = deleteConsecutive
                    }

-- Run or Raise Menu
largeXPConfig :: XPConfig
largeXPConfig = mXPConfig
                { font = xftFont
                , height = 60
                }
-- }}}
-- Key mapping {{{
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [
      ((modMask,                    xK_p     ), spawn "rofi -show")
    , ((modMask .|. shiftMask,      xK_p     ), spawn "/usr/local/bin/myrofi")
    , ((modMask .|. shiftMask,      xK_s     ), spawn "/usr/local/bin/rofi-pass")
    , ((modMask,                    xK_f     ), safePrompt "firefox" greenXPConfig)
    , ((modMask .|. shiftMask,      xK_Return), spawn $ XMonad.terminal conf)
    , ((modMask,                    xK_d     ), kill)
    , ((modMask .|. shiftMask,      xK_c     ), spawn "/usr/local/bin/countdown `rofi -dmenu -input /dev/null -p \"Countdown (seconds) > \"`")
    , ((0,                          xK_Insert), pasteSelection)
    , ((modMask,                    xK_Tab   ), toggleWS)
    , ((modMask,                    xK_n     ), spawn "urxvt -e wicd-curses")
    , ((modMask,                    xK_v     ), spawn "urxvt -e bash -c 'sudo tail -f /var/log/syslog'")

    -- Programs
    , ((modMask,                    xK_Print ), spawn "output=~/data/screenshots/$(date +%s).png; maim --select --nokeyboard $output && notify-send -u low -i $output 'Got it!' && firefox $output")
    , ((modMask,                    xK_o     ), spawn "firefox")
    , ((modMask,                    xK_y     ), spawn "urxvt -e bash -c 'yubioath'")
    , ((modMask,                    xK_g     ), spawn "urxvt -e bash -c 'dig +short google.com; ping 8.8.8.8'")
    , ((modMask .|. shiftMask,      xK_l     ), spawn "xscreensaver-command -lock")

    -- Media Keys
    , ((0,                          xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5; xbacklight | dzen2-gdbar -fg yellow -h 10 -w 100 -s o | dzen2 -p 1")
    , ((0,                          xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 5; xbacklight | dzen2-gdbar -fg yellow -h 10 -w 100 -s o | dzen2 -p 1")
    , ((0,                          xF86XK_AudioMute        ), spawn "pulsemixer --toggle-mute")
    , ((0,                          xF86XK_AudioLowerVolume ), spawn "pulsemixer --change-volume -5; pulsemixer --get-volume | awk '{print $1}' | dzen2-gdbar -fg purple -h 10 -w 100 -s o | dzen2 -p 1")
    , ((0,                          xF86XK_AudioRaiseVolume ), spawn "pulsemixer --change-volume +5; pulsemixer --get-volume | awk '{print $1}' | dzen2-gdbar -fg purple -h 10 -w 100 -s o | dzen2 -p 1")
    , ((0,                          xF86XK_AudioPrev        ), spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous && notify-send -t 1000 'Previous track'")
    , ((0,                          xF86XK_AudioNext        ), spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next && notify-send -t 1000 'Next track'")
    , ((0,                          xF86XK_AudioPlay        ), spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause && notify-send -t 1000 'Play/Pause'")
    , ((modMask,                    xK_Down                 ), spawn "amixer -q sset Master 5%-")
    , ((modMask,                    xK_Up                   ), spawn "amixer -q sset Master 5%+")
    , ((modMask .|. shiftMask,      xK_d                    ), spawn "setxkbmap de && notify-send 'Deutsch keyboard layout'")
    , ((modMask .|. shiftMask,      xK_u                    ), spawn "setxkbmap us && notify-send 'English keyboard layout'")

    -- layouts
    , ((modMask,                    xK_space                ), sendMessage NextLayout)
    , ((modMask .|. shiftMask,      xK_space                ), setLayout $ XMonad.layoutHook conf)          -- reset layout on current desktop to default
    , ((modMask,                    xK_b                    ), sendMessage ToggleStruts)
    , ((modMask .|. shiftMask, xK_g     ), windowPrompt
        def { autoComplete = Just 500000 }
        Goto allWindows)
    , ((modMask,                    xK_z                    ), windows W.focusDown)
    , ((modMask,                    xK_j                    ), windows W.focusDown)
    , ((modMask,                    xK_k                    ), windows W.focusUp  )
    , ((modMask .|. shiftMask,      xK_j                    ), windows W.swapDown)
    , ((modMask .|. shiftMask,      xK_k                    ), windows W.swapUp)
    , ((modMask,                    xK_Return               ), windows W.swapMaster)
    , ((modMask,                    xK_t                    ), withFocused $ windows . W.sink)
    , ((modMask,                    xK_h                    ), sendMessage Shrink)
    , ((modMask,                    xK_l                    ), sendMessage Expand)
    , ((modMask,                    xK_comma                ), sendMessage (IncMasterN 1))
    , ((modMask,                    xK_period               ), sendMessage (IncMasterN (-1)))

    --Urgency hooks
    {- , ((modMask,                    xK_BackSpace), focusUrgent) -}
    , ((modMask,                    xK_BackSpace), date)

    -- workspaces
    , ((modMask .|. controlMask,   xK_Right), nextWS)
    , ((modMask .|. shiftMask,     xK_Right), shiftToNext)
    , ((modMask .|. controlMask,   xK_Left ), prevWS)
    , ((modMask .|. shiftMask,     xK_Left ), shiftToPrev)

    -- quit, or restart
    , ((modMask,                   xK_c    ), spawn "killall -SIGUSR1 conky")
    , ((modMask,                   xK_x    ), spawn "killall conky; conky -c ~/.xmonad/conky_dzen | dzen2 -xs 2 -ta 'r' -e 'onstart=lower'; conky -c ~/.xmonad/conky_dzen_bottom | dzen2 -x '0' -y '10000' -h '15' -ta 'r' -dock")
    , ((modMask,                   xK_F1   ), spawn "~/.screenlayout/laptop.sh")
    , ((modMask,                   xK_F2   ), spawn "~/.screenlayout/work.sh")
    , ((modMask,                   xK_F3   ), spawn "~/.screenlayout/work_mirror.sh")
    , ((modMask,                   xK_r    ), spawn "killall conky dzen2; /usr/bin/xmonad --recompile && /usr/bin/xmonad --restart")
    , ((modMask,               xK_Down),  nextWS)
    , ((modMask,               xK_Up),    prevWS)
    , ((modMask .|. shiftMask, xK_Down),  shiftToNext)
    , ((modMask .|. shiftMask, xK_Up),    shiftToPrev)
    , ((modMask .|. shiftMask, xK_n), do
      spawn ("date>>" ++ "data/notes/quicknotes.txt")
      appendFilePrompt def "data/notes/quicknotes.txt"
    )
    , ((modMask .|. controlMask, xK_n), spawn "urxvt -e vim data/notes/quicknotes.txt")
    , ((modMask .|. controlMask, xK_s), sshPrompt def)
    , ((modMask .|. shiftMask, xK_t), sendMessage $ JumpToLayout "Tabbed Bottom Simplest")

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

