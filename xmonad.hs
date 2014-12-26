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
myXmonadBar = "killall dzen2; dzen2 -x '2010' -y '0' -w '1500' -ta 'l'"
myStatusBar = "killall conky; conky -c ~/.xmonad/.conky_dzen | dzen2 -x '750' -w '1500' -ta 'r' -y '0'"
{-myTrayer = "killall trayer; trayer --edge bottom --align right --SetDockType false  --SetPartialStrut false  --expand true  --transparent true --tint 0x000000 --height 23 --widthtype request --alpha 150 &"-}
myBitmapsDir = ".xmonad/bitmaps"
--
-- Main
main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    -- midTrayer <- spawnPipe myTrayer
    xmonad $ withUrgencyHookC dzenUrgencyHook { args = ["-bg", "red", "fg", "black", "-xs", "1", "-y", "25"] } urgencyConfig { remindWhen = Every 15 } $ defaultConfig
      { workspaces          = myWorkspaces
      , keys                = keys'
      , modMask             = modMask'
      -- , layoutHook          = layoutHook'
      -- , layoutHook          = myLayout
      , layoutHook          = customLayout
      , manageHook          = manageHook'
      , logHook             = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd >> updatePointer (Relative 0.9 0.9)
      , normalBorderColor   = colorNormalBorder
      , focusedBorderColor  = colorFocusedBorder
      , borderWidth         = 2
      , handleEventHook     = fullscreenEventHook --for chrome full screen-- {{{-- }}}
      , startupHook         = spawn "~/.xmonad/scripts/on-start.sh"
      , terminal            = "urxvt"
      , focusFollowsMouse   = False
}
--}}}


-- Hooks {{{
-- ManageHook {{{
manageHook' :: ManageHook
manageHook' = (composeAll . concat $
    [ [resource     =? r            --> doIgnore            |   r   <- myIgnores] -- ignore desktop
    , [className    =? c            --> doShift  "1"   |   c   <- myDev    ] -- move dev to main
    , [className    =? c            --> doShift  "2"    |   c   <- myWebs   ] -- move webs to main
    , [className    =? c            --> doShift  "3"    |   c   <- myVim    ] -- move vim to vim
    , [className    =? c            --> doShift	 "4"   |   c   <- myPidgin  ]
    , [className    =? c            --> doShift	 "4"   |   c   <- mySkype  ]
    , [className    =? c            --> doCenterFloat       |   c   <- myFloats ] -- float my floats
    , [name         =? n            --> doCenterFloat       |   n   <- myNames  ] -- float my names
    , [isFullscreen                 --> myDoFullFloat                           ]
    , [manageDocks]
    ])

    where

        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"

        -- classnames
        myWebs    = ["Firefox","Google-chrome","Chromium", "Chromium-browser","Iceweasel","iceweasel"]
        myPidgin  = ["Pidgin","Buddy List", "chat"]
        mySkype	  = ["Skype", "skype"]
        myDev	  = ["urxvt"]
        myVim	  = ["Gvim"]

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
      , ppVisible           =   dzenColor "white" "black" . pad
      , ppHidden            =   dzenColor "white" "black" . pad
      , ppHiddenNoWindows   =   dzenColor "#3D3D3D" "black" . pad
      , ppUrgent            =   dzenColor "black" "red" . pad
      , ppWsSep             =   " "
      , ppSep               =   " | "
      , ppLayout            =   dzenColor "#ebac54" "black" .
                                (\x -> case x of
                                    "Spacing 3 Tall"         -> "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Mirror Spacing 3 Tall"  -> "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Full"                   -> "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    _                        -> x
                                )
      , ppTitle             =   dzenColor "white" "MidnightBlue" . dzenEscape . (" "++) . (++" ")
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
colorFocusedBorder  = "red"


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
      ((modMask,                    xK_p        ), runOrRaisePrompt largeXPConfig)
    , ((modMask .|. shiftMask,      xK_Return   ), spawn $ XMonad.terminal conf)
    , ((modMask,                    xK_q        ), kill)
    , ((modMask .|. shiftMask,      xK_c        ), kill)

    -- Programs
    , ((modMask,                    xK_Print    ), spawn "cd ~/screenshots; scrot -t 20 -e 'notify-send -t 1000 $f'")
    , ((modMask,		            xK_o        ), spawn "firefox")
    , ((modMask,		            xK_Escape   ), spawn "~/.local/piyaz/piyaz")
    , ((modMask .|. shiftMask,      xK_n        ), spawn "gvim --remote-tab-silent ~/.notes")
    , ((modMask,		            xK_s        ), spawn "keepassx")
    , ((0,            xF86XK_ScreenSaver        ), spawn "xscreensaver-command -lock")
    , ((modMask .|. shiftMask,	    xK_l        ), spawn "xscreensaver-command -lock")
    , ((modMask .|. shiftMask,	    xK_m        ), spawn "spotify")

    -- Media Keys
    , ((modMask,                    xK_0                    ), spawn "amixer -q sset Master toggle")  -- XF86AudioMute
    , ((0,                          xF86XK_AudioMute        ), spawn "amixer -q sset Master toggle")  -- XF86AudioMute
    , ((0,                          xF86XK_AudioLowerVolume ), spawn "amixer -q sset Master 5%-; notify-send -t 1000 `amixer get Master | egrep -o \"[0-9]+%\"` ")     -- XF86AudioLowerVolume
    , ((0,                          xF86XK_AudioRaiseVolume ), spawn "amixer -q sset Master 5%+; notify-send -t 1000 `amixer get Master | egrep -o \"[0-9]+%\"`")     -- XF86AudioRaiseVolume.
    , ((modMask,                    xK_Down                 ), spawn "amixer -q sset Master 5%-")
    , ((modMask,                    xK_Up                   ), spawn "amixer -q sset Master 5%+")

    -- layouts
    , ((modMask,                    xK_space    ), sendMessage NextLayout)
    , ((modMask .|. shiftMask,      xK_space    ), setLayout $ XMonad.layoutHook conf)          -- reset layout on current desktop to default
    , ((modMask,                    xK_b        ), sendMessage ToggleStruts)
    , ((modMask,                    xK_n        ), refresh)
    , ((modMask,                    xK_Tab      ), windows W.focusDown)                         -- move focus to next window
    , ((modMask,                    xK_j        ), windows W.focusDown)
    , ((modMask,                    xK_k        ), windows W.focusUp  )
    , ((modMask .|. shiftMask,      xK_j        ), windows W.swapDown)                          -- swap the focused window with the next window
    , ((modMask .|. shiftMask,      xK_k        ), windows W.swapUp)                            -- swap the focused window with the previous window
    , ((modMask,                    xK_Return   ), windows W.swapMaster)
    , ((modMask,                    xK_t        ), withFocused $ windows . W.sink)              -- Push window back into tiling
    , ((modMask,                    xK_h        ), sendMessage Shrink)                          -- %! Shrink a master area
    , ((modMask,                    xK_l        ), sendMessage Expand)                          -- %! Expand a master area
    , ((modMask,                    xK_comma    ), sendMessage (IncMasterN 1))                  -- Increment the number of windows in the master area
    , ((modMask,                    xK_period   ), sendMessage (IncMasterN (-1)))               -- Deincrement the number of windows in the master area

    --Urgency hooks
    , ((modMask,                    xK_BackSpace), focusUrgent)

    -- workspaces
    , ((modMask .|. controlMask,   xK_Right     ), nextWS)
    , ((modMask .|. shiftMask,     xK_Right     ), shiftToNext)
    , ((modMask .|. controlMask,   xK_Left      ), prevWS)
    , ((modMask .|. shiftMask,     xK_Left      ), shiftToPrev)

    -- quit, or restart
    , ((modMask,                   xK_c         ), spawn "killall -SIGUSR1 conky")
    , ((modMask,                   xK_x         ), spawn "killall conky; conky -c ~/.xmonad/.conky_dzen | dzen2 -x '750' -w '1500' -ta 'r' -y '0'")
    , ((modMask,                   xK_F1        ), spawn "~/.screenlayout/laptop.sh")
    , ((modMask,                   xK_F2        ), spawn "~/.screenlayout/wooga.sh")
    , ((modMask,                   xK_F3        ), spawn "~/.screenlayout/tv.sh")
    --, ((modMask,                   xK_r         ), spawn "/usr/bin/xmonad --recompile && /usr/bin/xmonad --restart")

    -- cycle wallpaper
    , ((modMask,     xK_d         ), spawn "~/.xmonad/scripts/wall.sh") -- doesnt work
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
--
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e] [1, 0]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

