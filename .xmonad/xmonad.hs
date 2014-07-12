import XMonad 
import Data.Monoid
import System.Exit
import XMonad.Util.NamedScratchpad
import XMonad.Util.Scratchpad
import XMonad.ManageHook
import XMonad.Hooks.ManageDocks

import XMonad.Layout.NoBorders ( noBorders, smartBorders )

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Actions.WindowGo
import XMonad.Hooks.EwmhDesktops --fix openoffice squeezing
import XMonad.Hooks.SetWMName

myTerminal      = "urxvtc"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
myBorderWidth   = 1
myModMask       = mod4Mask

myWorkspaces :: [String]
myWorkspaces = ["shell","web","work","doc","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#444444"
myFocusedBorderColor = "#005577"
--scratchpads stuff
scratchpads :: NamedScratchpads
scratchpads = [
   -- NS "vimNote" "/usr/bin/urxvtc  -fn '-xos4-terminus-bold-*-*-*-16-*-*-*-*-iso10646-1,-misc-fixed-bold-r-normal--14-140-75-75-c-90-iso10646-1' -T vimNote -e vim ~/.mynotes" (title=? "vimNote") 
    NS "vimNote" "gvim --role notes note:todo" (role=? "notes") 
    (customFloating $ W.RationalRect (0) (0) (1/2) (4/5)),
    NS "xpad" "/usr/bin/xpad -N -s -t" (className =? "xpad") defaultFloating,
    NS "kanban" "/usr/bin/urxvtc -T kanban -e vim /mnt/data2/tom/apps/Simple_Kanban.html" (title=? "kanban") defaultFloating,
    NS "top" "/usr/bin/urxvtc -T spHtop -e htop" (title=? "spHtop") 
        (customFloating $ W.RationalRect (55/100) (1/2) (45/100) (1/2)),
    NS "tasque" "/usr/bin/tasque" (className =? "Tasque")
    (customFloating $ W.RationalRect (0) (0) (1/2) (4/5)),
    NS "rooter" "/usr/bin/urxvtc -name rootTerm -e sudo -i" (resource=? "rootTerm")
        (customFloating $ W.RationalRect (1/2) (1/4) (1/2) (3/4)),
    NS "ncmpc" "/usr/bin/urxvtc -name spNcmpc -e ncmpc" (resource=? "spNcmpc")
        (customFloating $ W.RationalRect (55/100) (0) (45/100) (2/3)),
    NS "dict" "/usr/bin/goldendict" (className =? "Goldendict") defaultFloating] where role = stringProperty "WM_WINDOW_ROLE"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm, xK_c), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((mod1Mask,               xK_F2     ), spawn "dmenu_run -fn '-*-terminus-medium-r-*-*-16-*-*-*-*-*-*-*'")
    --, ((modm,               xK_i     ), spawn "ibus-daemon --xim --panel=disable")
    , ((modm,               xK_f     ), runOrRaise "firefox" (className =? "Firefox"))
    , ((modm,               xK_s     ), namedScratchpadAction scratchpads "vimNote")
    , ((modm,               xK_d     ), namedScratchpadAction scratchpads "dict")
    , ((modm,               xK_w     ), namedScratchpadAction scratchpads "tasque")
    , ((modm,               xK_x     ), namedScratchpadAction scratchpads "xpad")
    , ((modm,               xK_p     ), namedScratchpadAction scratchpads "ncmpc")
    , ((modm,               xK_u     ), namedScratchpadAction scratchpads "rooter")
    , ((0,                  xK_Menu     ), namedScratchpadAction scratchpads "top")
    , ((modm,               xK_v     ), spawn "/home/tom/apps/vb/usr/share/viber/Viber")
    , ((modm,               xK_z     ), spawn "zim")
    , ((modm,               xK_t     ), runOrRaise "kile" (className =? "Kile"))
    , ((modm,               xK_o     ), spawn "okular")
    , ((modm,               xK_e     ), spawn "/home/tom/old/tool/eclipse/eclipse")
    , ((modm,               xK_g     ), spawn "/home/tom/old/tool/Gama16/Gama")
    , ((modm,               xK_a     ), spawn "sleep 0.2&&urxvtc -t mutt -e mutt")
    , ((modm,               xK_n     ), spawn "/home/tom/scripts/conky.dzen 2>/dev/null")
    , ((modm .|. shiftMask, xK_s     ), spawn "slock")
    , ((0,             0x1008ff14    ), spawn "/home/tom/scripts/mpd toggle")
    , ((0,             0x1008ff15    ), spawn "mpc stop")
    , ((0,             0x1008ff16    ), spawn "mpc prev")
    , ((0,             0x1008ff17    ), spawn "mpc next")
    --, ((0,             0x1008ff13    ), spawn "/usr/bin/pulseaudio-ctl up")
    --, ((0,             0x1008ff11    ), spawn "/usr/bin/pulseaudio-ctl down")
    --, ((0,             0x1008ff12    ), spawn "/usr/bin/pulseaudio-ctl mute")
    , ((0,             0x1008ff13    ), spawn "amixer -q sset Master 2+")
    , ((0,             0x1008ff11    ), spawn "amixer -q sset Master 2-")
    , ((0,             0x1008ff12    ), spawn "amixer -q sset Master toggle")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm .|. shiftMask, xK_f     ), spawn "/home/tom/scripts/pause_ff.sh")

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    --, ((mod1Mask,           xK_f),      setLayout $ XMonad.layoutHook conf)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_r     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm .|. shiftMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    --, ((modm              , xK_b     ), ToggleStruts <+> spawn "/home/tom/scripts/toggledzen.sh" <+> refresh)
   -- , ((modm              , xK_b     ), spawn "/home/tom/scripts/toggledzen.sh" <+> sendMessage ToggleStruts)
    , ((modm              , xK_b     ), sendMessage ToggleStruts )

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    ] 
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
--    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{i,b,v}, Move client to screen 1, 2, or 3
    --
    {--
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_i, xK_b, xK_v] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    --}

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
--myLayout = tiled ||| Mirror tiled ||| Full
--myLayout = tiled ||| noBorders Full
myLayout = smartBorders $ avoidStruts  $  tiled ||| noBorders Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 11/20
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:
myManageHook = composeAll . concat $
    [[className =? x                --> doShift ( myWorkspaces !! 0 ) | x <- myShells]
    , [className =?  x                -->  doShiftAndGo ( myWorkspaces !! 1 )    | x <- myBrowsers]
    , [className =?  x                --> doShiftAndGo ( myWorkspaces !! 2 )     | x <- myWorks]
    , [className =?  x                --> doShift  ( myWorkspaces !! 3 )         | x <- myDocs]
    , [title     =?   x                --> doShiftAndGo  ( myWorkspaces !! 4 )     | x <- myEmails]
   -- , [className =? "Qstardict"              --> doShift "5"
    , [className =?  x                --> doShift  ( myWorkspaces !! 5 )         | x <- myCommunications]
    , [className =?  x                --> doShift  ( myWorkspaces !! 8 )         | x <- myNotes]
  --  , [className =? "Korganizer"                    --> doShift "9"
    , [resource  =? "desktop_window" --> doIgnore]
    , [resource  =? "kdesktop"       --> doIgnore ]]
    where 
          myShells   = ["Urxvt"]
          myBrowsers = ["Firefox"]      
          myWorks    = ["Eclipse", "Gama", "Kile"]
          myDocs     = ["Evince", "llpp", "MuPDF", "Okular", "libreoffice-writer"]
          myEmails   = ["mutt"]
          myCommunications = ["Skype", "Viber"]
          myNotes    = ["Zim"]
          doShiftAndGo ws = doF (W.greedyView ws) <+> doShift ws

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
--myStartupHook = return ()
myStartupHook = ewmhDesktopsStartup >> setWMName "LG3D" -- deek

------------------------------------------------------------------------

--main = xmonad defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
--main = xmonad $ kde4Config {
main = do
    -- dzenLeftBar <- spawnPipe myXmonadBar
    -- dzenRightBar <- spawnPipe myStatusBar
    --xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig {
    xmonad $ ewmh defaultConfig {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = namedScratchpadManageHook scratchpads <+> myManageHook <+> manageDocks,
        handleEventHook    = myEventHook <+> docksEventHook,
--        logHook            = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd,
		-- logHook			   = myTopLeftLogHook dzenLeftBar <+> myTopRightLogHook dzenRightBar,
        startupHook        = myStartupHook
    }
