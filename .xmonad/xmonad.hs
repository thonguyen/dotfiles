import XMonad 
import Data.Monoid
import System.Exit
import XMonad.Util.NamedScratchpad
import XMonad.Util.Scratchpad
import XMonad.ManageHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog 
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ICCCMFocus

import Data.List
import Control.Applicative
import XMonad.Layout.NoBorders ( noBorders, smartBorders )
--import XMonad.Config.Kde
--import XMonad.Layout.NoBorders

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- DzenBoxLoggers imports
import XMonad (liftIO)
import XMonad.Util.Loggers
import Control.Exception as E

myTerminal      = "urxvtc"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
myBorderWidth   = 1
myModMask       = mod4Mask

myWorkspaces :: [String]
--myWorkspaces = ["shell","web","work","4","5","6","7","8","9"]
myWorkspaces            = clickable . (map dzenEscape) $ [
    "shell","www","work","doc","mail","6","7","8","9"] 
    where clickable l = [ "^ca(1,xdotool key super+" ++ show (n) ++ ")" ++  ws ++ "^ca()" | (i,ws) <- zip [1..] l, let n = i ]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#444444"
myFocusedBorderColor = "#005577"
--scratchpads stuff
scratchpads :: NamedScratchpads
scratchpads = [
    NS "vimNote" "/usr/bin/urxvtc  -fn '-xos4-terminus-bold-*-*-*-16-*-*-*-*-iso10646-1,-misc-fixed-bold-r-normal--14-140-75-75-c-90-iso10646-1' -T vimNote -e vim ~/.mynotes" (title=? "vimNote") 
    (customFloating $ W.RationalRect (1/90) (1/40) (1/3) (2/3)),
--    NS "xpad" "/usr/bin/xpad -N -s" (className =? "xpad") defaultFloating,
    NS "kanban" "/usr/bin/urxvtc -T kanban -e vim /mnt/data2/tom/apps/Simple_Kanban.html" (title=? "kanban") defaultFloating,
    NS "top" "/usr/bin/urxvtc -T spHtop -e htop" (title=? "spHtop") 
        (customFloating $ W.RationalRect (3/5) (1/2) (2/5) (1/2)),
    NS "korganizer" "/usr/bin/korganizer" (className =? "Korganizer") defaultFloating,
    NS "rooter" "/usr/bin/urxvtc -name rootTerm -e sudo -i" (resource=? "rootTerm")
        (customFloating $ W.RationalRect (1/100) (1/2) (5/9) (49/100)),
    NS "ncmpcpp" "/usr/bin/urxvtc -name spNcmpcpp -e ncmpcpp" (resource=? "spNcmpcpp")
        (customFloating $ W.RationalRect (5/9) (1/40) (4/9) (1/2)),
    NS "dict" "/usr/bin/qstardict" (className =? "Qstardict") defaultFloating]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm, xK_c), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((mod1Mask,               xK_F2     ), spawn "dmenu_run -fn '-*-terminus-medium-r-*-*-16-*-*-*-*-*-*-*'")
    --, ((modm,               xK_i     ), spawn "ibus-daemon --xim --panel=disable")
    , ((modm,               xK_f     ), spawn "firefox")
    , ((modm,               xK_s     ), namedScratchpadAction scratchpads "vimNote")
    , ((modm,               xK_d     ), namedScratchpadAction scratchpads "dict")
    , ((modm,               xK_w     ), namedScratchpadAction scratchpads "korganizer")
    , ((modm,               xK_x     ), namedScratchpadAction scratchpads "kanban")
    , ((modm,               xK_p     ), namedScratchpadAction scratchpads "ncmpcpp")
    , ((modm,               xK_u     ), namedScratchpadAction scratchpads "rooter")
    , ((0,                  xK_Menu     ), namedScratchpadAction scratchpads "top")
    , ((modm,               xK_v     ), spawn "/mnt/data2/tom/apps/Viber/Viber")
    , ((modm,               xK_z     ), spawn "zim")
    , ((modm,               xK_t     ), spawn "kile")
    , ((modm,               xK_y     ), spawn "urxvtc -e sudo shutdown")
    , ((modm,               xK_o     ), spawn "okular")
    , ((modm,               xK_e     ), spawn "/home/tom/old/tool/eclipse/eclipse")
    , ((modm,               xK_g     ), spawn "/home/tom/old/tool/Gama16/Gama")
    , ((modm,               xK_a     ), spawn "urxvtc -t mutt -e mutt")
    , ((modm,               xK_n     ), spawn "/home/tom/scripts/conky.dzen 2>/dev/null")
    , ((modm .|. shiftMask, xK_s     ), spawn "slock")
    , ((0,             0x1008ff14    ), spawn "/home/tom/scripts/mpd toggle")
    , ((0,             0x1008ff15    ), spawn "ncmpcpp stop")
    , ((0,             0x1008ff16    ), spawn "ncmpcpp prev")
    , ((0,             0x1008ff17    ), spawn "ncmpcpp next")
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
--myStartupHook = ewmhDesktopsStartup >> setWMName "LG3D" -- deek
myStartupHook = setWMName "LG3D" -- deek

------------------------------------------------------------------------
myXmonadBar = "dzen2 -title-name dzenleft -slave-name dzenleft -x '0' -y '0' -w '480' -ta 'l' -fg '" ++ colorWhiteAlt ++ "' -bg '" ++ colorBlack ++ "' -fn '" ++ dzenFont ++ "'"
myStatusBar = "dzen2 -title-name dzenright -slave-name dzenright -x '480' -w '800' -ta 'r' -bg '" ++ colorBlack ++ "' -y '0' -fn '" ++ dzenFont ++ "'"
--myStatusBar = "conky -c /home/tom/.conkyrcdzen| dzen2 -x '480' -w '780' -ta 'r' -bg '#1B1D1E' -y '0' -fn '-*-terminus-medium-r-*-*-16-*-*-*-*-*-*-*'"


--main = xmonad defaults
--main = xmonad $ kde4Config 

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
--main = xmonad $ kde4Config {
main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig {
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
		logHook			   = myTopLeftLogHook dzenLeftBar <+> myTopRightLogHook dzenRightBar,
        startupHook        = myStartupHook
    }
--Bar
myDzenFGColor = "#555555"
myDzenBGColor = "#222222"
myNormalFGColor = "#ffffff"
myNormalBGColor = "#0f0f0f"
myFocusedFGColor = "#f0f0f0"
myFocusedBGColor = "#333333"
myUrgentFGColor = "#0099ff"
myUrgentBGColor = "#0077ff"
myIconFGColor = "#777777"
myIconBGColor = "#0f0f0f"
myPatternColor = "#1f1f1f"
mySeperatorColor = "#555555"

-- Colors, fonts and paths
dzenFont = "-*-montecarlo-medium-r-normal-*-14-*-*-*-*-*-*-*"
colorBlack = "#020202" --Background
colorBlackAlt = "#1c1c1c" --Black Xdefaults
colorGray = "#444444" --Gray
colorGrayAlt = "#101010" --Gray dark
colorGrayAlt2 = "#404040"
colorGrayAlt3 = "#252525"
colorWhite = "#a9a6af" --Foreground
colorWhiteAlt = "#9d9d9d" --White dark
colorWhiteAlt2 = "#b5b3b3"
colorWhiteAlt3 = "#707070"
colorMagenta = "#8e82a2"
colorBlue = "#44aacc"
colorBlueAlt = "#3955c4"
colorRed = "#f7a16e"
colorRedAlt = "#e0105f"
colorGreen = "#66ff66"
colorGreenAlt = "#558965"
boxLeftIcon = "/home/tom/.xmonad/icons/boxleft.xbm" --left icon of dzen boxes
boxLeftIcon2 = "/home/tom/.xmonad/icons/boxleft2.xbm" --left icon2 of dzen boxes
boxRightIcon = "/home/tom/.xmonad/icons/boxright.xbm" --right icon of dzen boxes
panelHeight = 16 --height of top and bottom panels
boxHeight = 14 --height of dzen logger box
-- Uses dzen format to draw a "box" arround a given text
dzenBoxStyle :: BoxPP -> String -> String
dzenBoxStyle bpp t =
	"^fg(" ++ (boxColorBPP bpp) ++
	")^i(" ++ (leftIconBPP bpp)  ++
	")^ib(1)^r(1280x" ++ (show $ boxHeightBPP bpp) ++
	")^p(-1280)^fg(" ++ (fgColorBPP bpp) ++
	")" ++ t ++
	"^fg(" ++ (boxColorBPP bpp) ++
	")^i(" ++ (rightIconBPP bpp) ++
	")^fg(" ++ (bgColorBPP bpp) ++
	")^r(1280x" ++ (show $ boxHeightBPP bpp) ++
	")^p(-1280)^fg()^ib(0)"
-- Logger version of dzenBoxStyle
dzenBoxStyleL :: BoxPP -> Logger -> Logger
dzenBoxStyleL bpp l = (fmap . fmap) (dzenBoxStyle bpp) l

-- Uses dzen format to make dzen text clickable
dzenClickStyle :: CA -> String -> String
dzenClickStyle ca t = "^ca(1," ++ leftClickCA ca ++
	")^ca(2," ++ middleClickCA ca ++
	")^ca(3," ++ rightClickCA ca ++
	")^ca(4," ++ wheelUpCA ca ++
	")^ca(5," ++ wheelDownCA ca ++
	")" ++ t ++
	"^ca()^ca()^ca()^ca()^ca()"

-- Top left bar logHook
--myTopLeftLogHook :: Handle -> X ()
myTopLeftLogHook h = dynamicLogWithPP . namedScratchpadFilterOutWorkspacePP $ defaultPP
	{ 
	ppOrder           = \(ws:_:x:_) ->  [ws,x]
	, ppSep             = " "
	, ppWsSep           = ""
	, ppCurrent         = dzenBoxStyle blue2BBoxPP
	, ppUrgent          = dzenBoxStyle green2BBoxPP
	, ppVisible         = dzenBoxStyle blackBoxPP
	, ppHiddenNoWindows = dzenBoxStyle blackBoxPP
	, ppHidden          = dzenBoxStyle whiteBoxPP
	, ppTitle 			= dzenBoxStyle blueBoxPP 
	, ppOutput          = hPutStrLn h
--	, ppExtras          =  
	} {--where
	  dzenClickWorkspace ws = "^ca(1," ++ xdo "w;" ++ xdo index ++ ")" ++ "^ca(3," ++ xdo "w;" ++ xdo index ++ ")" ++ ws ++ "^ca()^ca()" where 
		wsIdxToString Nothing = "1" 
		wsIdxToString (Just n) = show $ mod (n+1) $ length myWorkspaces
		index = wsIdxToString (elemIndex ws myWorkspaces)
		xdo key = "/usr/bin/xdotool key super+" ++ key

 --}
-- Top right bar logHook
myTopRightLogHook h = dynamicLogWithPP defaultPP
	{ ppOutput = hPutStrLn h
	, ppOrder  = \(_:_:_:x) -> x
	, ppSep    = " "
--	, ppExtras = [ myBat, myCpuL, myMem, myTemp, myWifi, myBat ]
	, ppExtras = [ myBat, myTemp, myFan, myMem, date "%a %b %d %H:%M"]
	}
-- BotRight Loggers
myBat =
        (dzenBoxStyleL gray2BoxPP $ labelL "BAT") ++!
        (dzenBoxStyleL blueBoxPP $ batPercent 30 colorRed) ++!
        (dzenBoxStyleL whiteBoxPP batStatus)

myTemp =
        (dzenBoxStyleL gray2BoxPP $ labelL "TEMP") ++!
        (dzenBoxStyleL blueBoxPP $ cpuTemp 1 70 colorRed) 
myFan =
        (dzenBoxStyleL gray2BoxPP $ labelL "FAN") ++!
        (dzenBoxStyleL blueBoxPP $ fanSpeed)
--myCpu =
--        (dzenBoxStyleL gray2BoxPP $ labelL "CPU") ++!
--        (dzenBoxStyleL blueBoxPP $ cpuUsage "/tmp/haskell-cpu-usage.txt" 70 colorRed)
myMem =
        (dzenBoxStyleL gray2BoxPP $ labelL "MEM") ++!
        (dzenBoxStyleL blueBoxPP $ memUsage [percMemUsage, totMBMemUsage])
        {--myWifi =
        (dzenBoxStyleL blueBoxPP wifiSignal)
--}
-- Battery percent
batPercent :: Int -> String -> Logger
batPercent v c = fileToLogger format "N/A" "/sys/class/power_supply/BAT0/capacity" where
        format x = if ((read x::Int) <= v) then "^fg(" ++ c ++ ")" ++ x ++ "%^fg()" else (x ++ "%")

-- Battery status
batStatus :: Logger
batStatus = fileToLogger format "Unknown" "/sys/class/power_supply/BAT0/status" where
        format x 
                | x == "Unknown" = "AC"
                | x == "Discharging" = ""
                | otherwise = x

-- CPU temperature
cpuTemp :: Int -> Int -> String -> Logger
cpuTemp n v c = initL $ concatWithSpaceL $ map (fileToLogger divc "0") pathtemps where
        pathtemps = map (++"/thermal_zone/temp") $ map ("/sys/bus/acpi/devices/LNXTHERM:0"++) $ take n $ map show [0..]
        divc x = crit $ div (read x::Int) 1000
        crit x = if (x >= v) then "^fg(" ++ c ++ ")" ++ show x ++ "°C^fg()" else (show x ++ "°C")

-- FAN speed
fanSpeed :: Logger
fanSpeed = fileToLogger getRpm "speed:" "/proc/acpi/ibm/fan" where
        getRpm x = (words (lines x !! 1) !! 1) ++ "Rpm"

-- Memory usage
memUsage :: [(String -> String)] -> Logger
memUsage xs = initL $ concatWithSpaceL $ map funct xs where
        funct x = fileToLogger x "N/A" "/proc/meminfo"

_memUsed x = (_memValues x !! 0) - ((_memValues x !! 2) + (_memValues x !! 3) + (_memValues x !! 1))
_memPerc x = div (_memUsed x * 100) (_memValues x !! 0)
_memValues x = map (getValues x) $ take 4 [0..] where
        getValues x n = read (words (lines x !! n) !! 1)::Int

freeBMemUsage x = (show $ _memValues x !! 1) ++ "B"
freeMBMemUsage x = (show $ div (_memValues x !! 1) 1024) ++ "MB"
totBMemUsage = (++"B") . show . _memUsed
totMBMemUsage = (++"MB") . show . (`div` 1024) . _memUsed
percMemUsage = (++"%") . show . _memPerc


-- Concat two Loggers
(++!) :: Logger -> Logger -> Logger
l1 ++! l2 = (liftA2 . liftA2) (++) l1 l2

-- Concat a list of loggers
concatL :: [Logger] -> Logger
concatL [] = return $ return ""
concatL (x:xs) = x ++! concatL xs

-- Concat a list of loggers with spaces between them
concatWithSpaceL :: [Logger] -> Logger
concatWithSpaceL [] = return $ return ""
concatWithSpaceL (x:xs) = x ++! (labelL " ") ++! concatWithSpaceL xs

-- Label
labelL :: String -> Logger
labelL = return . return

-- Init version for Logger
initL :: Logger -> Logger
initL = (fmap . fmap) initNotNull


initNotNull :: String -> String
initNotNull [] = "0\n"
initNotNull xs = init xs

tailNotNull :: [String] -> [String]
tailNotNull [] = ["0\n"]
tailNotNull xs = tail xs

-- Convert the content of a file into a Logger
fileToLogger :: (String -> String) -> String -> FilePath -> Logger
fileToLogger f e p = do
    let readWithE f1 e1 p1 = E.catch (do
        contents <- readFile p1
        return $ f1 (initNotNull contents) ) ((\_ -> return e1) :: E.SomeException -> IO String)
    str <- liftIO $ readWithE f e p
    return $ return str

-- Dzen logger box pretty printing themes
gray2BoxPP :: BoxPP
gray2BoxPP = BoxPP
	{ bgColorBPP   = colorBlack
	, fgColorBPP   = colorGray
	, boxColorBPP  = colorGrayAlt
	, leftIconBPP  = boxLeftIcon2
	, rightIconBPP = boxRightIcon
	, boxHeightBPP = boxHeight
	}

blueBoxPP :: BoxPP
blueBoxPP = BoxPP
	{ bgColorBPP   = colorBlack
	, fgColorBPP   = colorBlue
	, boxColorBPP  = colorGrayAlt
	, leftIconBPP  = boxLeftIcon
	, rightIconBPP = boxRightIcon
	, boxHeightBPP = boxHeight
	}

blue2BoxPP :: BoxPP
blue2BoxPP = BoxPP
	{ bgColorBPP   = colorBlack
	, fgColorBPP   = colorBlue
	, boxColorBPP  = colorGrayAlt
	, leftIconBPP  = boxLeftIcon2
	, rightIconBPP = boxRightIcon
	, boxHeightBPP = boxHeight
	}

whiteBoxPP :: BoxPP
whiteBoxPP = BoxPP
	{ bgColorBPP   = colorBlack
	, fgColorBPP   = colorWhiteAlt
	, boxColorBPP  = colorGrayAlt
	, leftIconBPP  = boxLeftIcon
	, rightIconBPP = boxRightIcon
	, boxHeightBPP = boxHeight
	}

blackBoxPP :: BoxPP
blackBoxPP = BoxPP
	{ bgColorBPP   = colorBlack
	, fgColorBPP   = colorBlack
	, boxColorBPP  = colorGrayAlt
	, leftIconBPP  = boxLeftIcon
	, rightIconBPP = boxRightIcon
	, boxHeightBPP = boxHeight
	}

white2BBoxPP :: BoxPP
white2BBoxPP = BoxPP
	{ bgColorBPP   = colorBlack
	, fgColorBPP   = colorBlack
	, boxColorBPP  = colorWhiteAlt
	, leftIconBPP  = boxLeftIcon2
	, rightIconBPP = boxRightIcon
	, boxHeightBPP = boxHeight
	}

blue2BBoxPP :: BoxPP --current workspace
blue2BBoxPP = BoxPP
	{ bgColorBPP   = colorBlack
	, fgColorBPP   = colorBlack
	, boxColorBPP  = colorBlue
	, leftIconBPP  = boxLeftIcon2
	, rightIconBPP = boxRightIcon
	, boxHeightBPP = boxHeight
	}

green2BBoxPP :: BoxPP --urgent workspace
green2BBoxPP = BoxPP
	{ bgColorBPP   = colorBlack
	, fgColorBPP   = colorBlack
	, boxColorBPP  = colorGreen
	, leftIconBPP  = boxLeftIcon2
	, rightIconBPP = boxRightIcon
	, boxHeightBPP = boxHeight
	}

-- Dzen box pretty config
data BoxPP = BoxPP
        { bgColorBPP :: String
        , fgColorBPP :: String
        , boxColorBPP :: String
        , leftIconBPP :: String
        , rightIconBPP :: String
        , boxHeightBPP :: Int
        }

-- Dzen clickable area config
data CA = CA
        { leftClickCA :: String
        , middleClickCA :: String
        , rightClickCA :: String
        , wheelUpCA :: String
        , wheelDownCA :: String
        }
        
staticWs = ["shell", "www", "work"]
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent = dzenColor "#ebac54" "#1B1D1E"
      , ppVisible = dzenColor "white" "#1B1D1E"
      , ppHidden = dzenColor "white" "#1B1D1E" . \wsId -> if wsId == "NSP" then "" else wsId
      , ppHiddenNoWindows  = \wsId -> if wsId `notElem` staticWs || wsId == "NSP" then "" else wrap ("^p(2)^ib(1)^fg(" ++ myPatternColor ++ ")^fg(" ++ myDzenFGColor ++ ")^bg()^p()``^p(2)") ("^p(2)^fg(" ++ myPatternColor ++ ")^fg(" ++ myNormalBGColor ++ ")^ib(0)^fg()^bg()^p()") . dropIx $ wsId 
      , ppUrgent = dzenColor "black" "red"
      , ppWsSep = " "
      , ppSep = " | "
      , ppLayout = dzenColor "#ebac54" "#1B1D1E" 
      , ppTitle = (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
      , ppOutput = hPutStrLn h
    } 
    where dropIx wsId = if (':' `elem` wsId) then drop 2 wsId else wsId  
