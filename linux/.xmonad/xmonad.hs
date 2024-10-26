import XMonad
import System.Exit
import Data.Monoid
import Data.Ratio

-- Layout
import XMonad.Layout.NoBorders
import XMonad.Layout.MultiToggle 
import XMonad.Layout.Gaps (GapMessage(ToggleGaps), gaps)
import XMonad.Layout.Spacing
import XMonad.Layout.MultiToggle.Instances 
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Renamed (renamed, Rename(..))
import XMonad.Layout.PerScreen (ifWider)

-- Util
import XMonad.Util.Run(spawnPipe, hPutStrLn)
import XMonad.Util.SpawnOnce(spawnOnce)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.NamedScratchpad

-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, dynamicLogString, xmobarPP, xmobarColor, wrap, shorten, PP(..))
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.DynamicProperty (dynamicPropertyChange)
import XMonad.Hooks.ManageHelpers (doSideFloat, doRectFloat, Side(NE))
import XMonad.Hooks.SetWMName (setWMName)

-- Actions
import XMonad.Actions.UpdatePointer (updatePointer)

-- Other
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import System.IO

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#c4451d"


-- My functions
currentScreen :: X Int
currentScreen = (fromIntegral . W.screen . W.current) `fmap` gets windowset 

screenLeft = 1
    -- curscreen <- (fromIntegral . W.screen . W.current) `fmap` gets windowset :: X Int
    
  

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    -- , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

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

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Toggle full screen
    , ((modm,               xK_f     ), sendMessage $ Toggle FULL)

    -- Push window back into tiling
    , ((modm .|. shiftMask, xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm .|. shiftMask, xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_e     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_r     ), spawn "xmonad --recompile; killall xmobar; xmonad --restart; notify-send 'XMonad restarted'")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


myAdditionalKeys :: [(String, X ())]
myAdditionalKeys = 
    [ ("C-M4-m", namedScratchpadAction myScratchPads "spotify")
    , ("C-M4-j", namedScratchpadAction myScratchPads "jira")
    , ("C-M4-k", namedScratchpadAction myScratchPads "station")
    , ("C-M4-t", namedScratchpadAction myScratchPads "term")
    , ("C-M4-g", sendMessage $ ToggleGaps)
    ] ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [(("C-M4-" ++ key), screenWorkspace sc >>= flip whenJust (windows . W.view))
        | (key, sc) <- zip ["s", "a"] [0..]]
        -- DP-1, HDMI-0, eDP-1-1
        -- | (key, sc) <- zip ["d", "a", "s"] [0..]]

  

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
--                              LAYOUTS
------------------------------------------------------------------------
rotatedScreenWidth :: Dimension
rotatedScreenWidth = 2160

myLayout = smartBorders
  -- $ renamed [CutWordsLeft 2]
  $ mkToggle (NOBORDERS ?? FULL ?? EOT)
  $ spacing 16
  $ gaps [ (L, 16), (R, 16), (U, 16), (D, 16) ]
  $ (smartTiled ||| Mirror tiled ||| smartThreeCol ||| Full)
  where
     -- threeCol = ThreeColMid 1 (1/10) (1/2)
     tiled    = Tall 1 (3/100) (1/2)
  
     smartTiled = ifWider rotatedScreenWidth tiled (Mirror tiled)

     smartThreeCol = ifWider rotatedScreenWidth (ThreeColMid 1 (1/10) (1/2)) (Mirror (ThreeColMid 1 (1/10) (1/2)))
     



------------------------------------------------------------------------
--                            SCRATCHPADS
------------------------------------------------------------------------
jiraAppId :: String
jiraAppId = "goffgofdneoakogfaidbcphepgepldle"

runBraveAppCmd :: String -> String
runBraveAppCmd appId = "/opt/brave.com/brave/brave-browser --profile-directory=Default --app-id=" ++ appId

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "spotify" spawnSpotify findSpotify manageSpotify
                , NS "jira" spawnJira findJira manageJira
                , NS "term" spawnTerm findTerm manageTerm
                , NS "station" spawnStation findStation manageStation
                ]
  where
    spawnSpotify  = "spotify -n spotify"
    findSpotify   = resource =? "spotify"  
    manageSpotify = customFloating centerRect

    spawnJira = runBraveAppCmd jiraAppId
    findJira  = resource =? ("crx_" ++ jiraAppId)
    manageJira = customFloating centerRect

    spawnTerm = "kitty --name my-terminal"
    findTerm  = resource =? "my-terminal" 
    manageTerm = customFloating centerRect

    spawnStation = "Station-1.65.0-x86_64.AppImage"
    findStation  = className =? "Station" 
    manageStation = customFloating centerRect

------------------------------------------------------------------------
--                              HOOKS
------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
centerRect :: W.RationalRect
centerRect = (W.RationalRect (1 % 8) (1 % 8) (3 % 4) (3 % 4))

myManageHook = composeAll
    [ className =? "MPlayer"                --> doRectFloat centerRect
    , className =? "Gimp"                   --> doRectFloat centerRect
    , resource  =? ("crx_" ++ jiraAppId)    --> doRectFloat centerRect
    , title     =? "Picture in picture"     --> doSideFloat NE
    , resource  =? "desktop_window"         --> doIgnore
    , resource  =? "kdesktop"               --> doIgnore
    , role      =? "GtkFileChooserDialog"   --> doRectFloat centerRect
    ] <+> namedScratchpadManageHook myScratchPads
  where role = stringProperty "WM_WINDOW_ROLE"

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- myEventHook = mempty
myEventHook =
  composeAll
  [ dynamicPropertyChange "WM_NAME" (resource =? "spotify" --> floating) 
  ]
  where floating  = customFloating $ centerRect

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook :: X ()
myLogHook = updatePointer (0.1, 0.1) (0.1, 0.1)
-- myLogHook = dynamicLogString xmobarPP >>= (\x -> io $ appendFile "/tmp/xmobar_out" (x ++ "\n")) 

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = setWMName "LG3D"
  -- spawnOnce "stalonetray"


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  xmproc0 <- spawnPipe "xmobar -x 0 /home/porcupine/.config/xmobar/xmobarrc"
  xmproc1 <- spawnPipe "xmobar -x 1 /home/porcupine/.config/xmobar/xmobarrc"
  xmproc2 <- spawnPipe "xmobar -x 2 /home/porcupine/.config/xmobar/xmobarrc"
  xmonad $ docks def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = avoidStruts $ myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP
                             { ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x  >> hPutStrLn xmproc2 x
                             , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
                             , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
                             , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                             , ppHiddenNoWindows = xmobarColor "#F07178" ""        -- Hidden workspaces (no windows)
                             , ppTitle = xmobarColor "#d0d0d0" "" . shorten 60     -- Title of active window in xmobar
                             , ppSep =  "<fc=#666666> | </fc>"                     -- Separators in xmobar
                             , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                             -- , ppExtras  = [windowCount]                         -- # of windows current workspace
                             , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                             },
        startupHook        = myStartupHook
    } `additionalKeysP` myAdditionalKeys


