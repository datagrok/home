{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}

-- TODO: always configure specific workspaces with specific layouts, send
-- specific programs to specific workspaces:
--      9: chat. IRC in left large area, skinny IM client and windows on right.
--      8: mail. Evolution/thunderbird goes here by default.

-- TODO: configurably lock a workspace to a screen, so e.g. the small monitor
-- always shows 'chat'

-- TODO: Deal with stalonetray sanely. Discover why 'trayer' doesn't work for
-- me anymore.

-- TODO: Find a visualization for programs-on-workspaces that behaves sanely
-- under Xmonad's screens model. (Gnome's gets a bit confused.)

module Main (main) where

-- With explicit import lists I finally know where these things are coming
-- from. But might there be a way to simplify? Move some of this stuff to its
-- own module to reduce the number of imports per module?

import Data.Map(Map,union,(\\),mapEither,fromList)
import Data.Monoid(All(All),(<>))
import System.Exit(exitSuccess)
import System.IO(hPutStrLn, stderr)
import XMonad
import XMonad.Actions.DwmPromote(dwmpromote)
import XMonad.Actions.UpdatePointer(updatePointer)
import XMonad.Config.Desktop(desktopLayoutModifiers)
import XMonad.Config.Gnome(gnomeConfig)
import XMonad.Hooks.EwmhDesktops(fullscreenEventHook)
import XMonad.Hooks.SetWMName(setWMName)
import XMonad.Layout.Decoration(inactiveBorderColor,activeBorderColor,Theme,inactiveColor,inactiveTextColor,activeTextColor,activeColor,inactiveBorderColor,decoHeight)
import XMonad.Layout.DwmStyle(dwmStyle)
import XMonad.Layout.ResizableTile(ResizableTall(ResizableTall),MirrorResize(MirrorShrink,MirrorExpand))
import XMonad.Layout.ShowWName(showWName', swn_font)
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.TabBarDecoration(shrinkText)
import XMonad.Layout.ThreeColumns(ThreeCol(ThreeCol))
import XMonad.Prompt
import XMonad.Prompt.Shell(shellPrompt)
import XMonad.Prompt.Theme(themePrompt)
import XMonad.StackSet(greedyView,shift,view)
import XMonad.Util.Themes(theme,listOfThemes)

-- Does the use of 'where' make any difference here?
--      main = x y z
--          where
--              y = foo
--              z = bar
-- vs.
--      main = x y z
--      y = foo
--      z = bar

-- I want the equivalent of showWName for the desktop layout algorithm

main :: IO ()
main = xmonad $ gnomeConfig
        { layoutHook         = desktopLayoutModifiers
            -- $ ModifiedLayout MyResizeScreen 
            $ showWName' def { swn_font = bigfont }
            -- $ layoutHints
            -- Stalonetray just can't decide how much of my screen it wants.
            -- For some reason I never could get 'onWorkspace' to work well.
            -- $ onWorkspace "chat/music" (IM (320/1680) (Role "buddy_list"))
            -- $ onWorkspace "chat/music" (combineTwo (TwoPane delta (320/1680)) (Mirror tiled) (Full))
            $ decorateWindows
            $ ThreeCol 1 (3/100) (594/2560) ||| spiral (1050/1680) ||| tiled ||| Mirror tiled ||| Full ||| projector
        , keys               = keys'
        , manageHook         = manageHook' <> manageHook gnomeConfig
        , logHook            = updatePointer (0.5, 0.5) (0, 0) <> logHook gnomeConfig
        , terminal           = "x-terminal-emulator"
        , borderWidth        = 0
        , normalBorderColor  = inactiveBorderColor myTheme --"#666666"
        , focusedBorderColor = activeBorderColor myTheme --"#d78d07"
        , workspaces         = workspaces'
        , handleEventHook    = eventHook'
        , startupHook        = startupHook gnomeConfig >> setWMName "LG3D"
        }


-- Configuration settings used to override the default, above.
myTheme       = theme $ listOfThemes!!2     -- I like the second theme in the list.
floatClasses  = ["display", "Xwud", "fontforge", "oclock", "Clock"] -- These windows always float by default
ignoreClasses = ["Audacious"]
tiled         = Tall nmaster delta ratio
 -- Make one of the 2 master windows 800x600 in the upper left corner of my 1440x900 display.
projector     = ResizableTall 2 (20/1440) (800/1440) [600/(900/2)]
nmaster       = 1
delta         = 64/1680              -- adjust 64 pixels at a time on my 1680px wide monitor
ratio         = (1680-640)/1680      -- main takes all but 640 pixels on my 1680px wide monitor
bigfont       = "xft:Ubuntu-10"

-- TODO I wish I could lock sets of workspaces to screens. So picking workspace
-- 1-6 would always switch to screen 1 before changing, and 7-9 would switch to
-- screen 2 before changing.
workspaces'   = ["1", "2", "3", "4", "5", "6", "7", "Mail", "Chat"]


manageHook'   = composeAll [ className =? c --> doFloat  | c <- floatClasses ] <>
                composeAll [ className =? c --> doIgnore | c <- ignoreClasses ] <>
                composeAll [ className =? "Pidgin" --> doShift "Chat"
                           , className =? "Xchat-gnome" --> doShift "Chat"
                           , className =? "Evolution" --> doShift "Mail"
                           , className =? "stalonetray" --> doShift "Chat"
                           ]


-- Sometimes I like dwmStyle, sometimes I like tabBar. Both have warts that I'd
-- like to fix, and I pick whichever is less anoyying. TODO
decorateWindows = dwmStyle shrinkText myTheme
-- decorateWindows = tabBar shrinkText myTheme Bottom . resizeVerticalBottom (fromIntegral (decoHeight myTheme))
-- $ tabBar shrinkText myTheme Bottom . resizeVerticalBottom (fromIntegral (decoHeight myTheme))


-- Keybindings: some attempts to specify keybindings in a uniform, declaritive,
-- boilerplate-free way. To add or replace a keybinding, add a Map item to Just
-- an X action. To remove, add a Map item to Nothing.
keys' :: XConfig Layout -> Map (KeyMask, KeySym) (X ())
keys' x = union addkeys $ origkeys \\ delkeys
    where
        origkeys = keys def x
        (delkeys, addkeys) = mapEither partitioner $ mykeys $ modMask x

-- Used by keys' to take apart the Just/Nothing dichotomy.
partitioner :: Maybe a -> Either (X ()) a
partitioner (Nothing) = Left $ return ()
partitioner (Just y)  = Right y

-- A sortakinda declarative mapping of keys to either Nothing or X Actions,
-- consumed by keys'.
mykeys :: KeyMask -> Map (KeyMask, KeySym) (Maybe (X ()))
mykeys mod = fromList $
        -- Kill the default bindings for w, e, and r
        [ ((mod .|. mask, stringToKeysym key), Nothing)
            | key <- ["w", "e", "r"]
            , mask <- [noMask, shiftMask]
        ]
        ++
        [ ((mod .|. mask, stringToKeysym key), Just action) | (mask, key, action) <- 
            -- Assign workspace view/send to grid of keys 123/qwe/asd, so I can
            -- navigate through all with my left hand. Unfortunately I haven't
            -- got used to this because I don't have a good workspaces-in-use
            -- visualization to go with it. Mod+key to view, mod+shift+key to
            -- send.
            [ (m, key, windows $ f sc)
                | (key, sc) <- zip ["1", "2", "3", "q", "w", "e", "a", "s", "d"] workspaces'
                , (f  , m ) <- [(greedyView, noMask), (shift, shiftMask)]
            ]
            ++
            -- Assign screens to keys z/x/c: use mod to view, mod+shift to send
            [ (m, key, screenWorkspace sc >>= flip whenJust (windows . f))
                | (key, sc) <- zip ["z", "x", "c"] [0..]
                , (f  , m ) <- [(view, noMask), (shift, shiftMask)]
            ]
            ++
            -- Misc. other bindings
            [ (noMask      , "b"      , spawn "sensible-browser") -- "browser"
            , (noMask      , "r"      , shellPrompt (themedXPConfig myTheme)) -- "run"
            , (noMask      , "Return" , dwmpromote)
            , (controlMask , "Return" , spawn "x-terminal-emulator -e screen")
            , (controlMask , "t"      , themePrompt (themedXPConfig myTheme))
            , (shiftMask   , "F10"    , io exitSuccess) -- %! Quit xmonad
            , (noMask      , "F10"    , restart "xmonad" True) -- %! Restart xmonad
            , (controlMask , "k"      , kill)
            , (shiftMask   , "h"      , sendMessage MirrorShrink)
            , (shiftMask   , "l"      , sendMessage MirrorExpand)
            ]
        ]
    where
        -- Actually all the places this I use 'noMask' above actually ends up
        -- meaning "no *additional* mask besides 'mod', which is used for
        -- everything."
        noMask = 0


-- I want a single point of configuration for theme-related things. This
-- creates an XPConfig (a configuration for xprompt) from a theme.
-- Unfortunately, changing the theme 'live' with themePrompt affects only the
-- window decorations, not the prompts. Don't know how that works yet. TODO
themedXPConfig :: Theme -> XPConfig
themedXPConfig t = def 
        { font              = "xft:Ubuntu-10" -- fontName t
        , bgColor           = inactiveColor t
        , fgColor           = inactiveTextColor t
        , fgHLight          = activeTextColor t
        , bgHLight          = activeColor t
        , borderColor       = inactiveBorderColor t
        , height            = decoHeight t
        , promptBorderWidth = 1
        , position          = Bottom
        , historySize       = 256
        , defaultText       = []
        , autoComplete      = Nothing
}


-- TODO: I wish I could configure events to occur while the modifier key is
-- pressed, and be undone (or have other events occur) when released. Goal:
-- hide all decorations until mod is pressed. While pressed, a clock, window
-- names, current desktop name, window list, and graphical desktop summary and
-- system tray appear. When released the information disappears.
--
-- Thus-far failing (so commented and stubbed) experiments to build my own
-- low-level eventHook that will react to press and release follow.

-- eventHook' (KeyEvent {ev_event_type = t, ev_state = m, ev_keycode = code})
--     | t == keyRelease = withDisplay $ \dpy -> do
--         s  <- io $ keycodeToKeysym dpy code 0
--         mClean <- cleanMask m
--         ks <- asks keyActions
--         userCodeDef True ( io ( hPutStrLn stderr . show ( s ))) --return ()
        -- userCodeDef () $ whenJust (Data.Map.lookup (mClean, s) ks) id
-- eventHook' e = io $ hPutStrLn stderr . show $ e --return ()
-- eventHook' _ = return (All True)

eventHook' e = do
    fullscreenEventHook e
    handleEventHook gnomeConfig e
    dummyEventHook e

--dummyEventHook :: Event -> X All
--dummyEventHook KeyEvent {ev_event_type = t, ev_state = m, ev_keycode = code}
--  | t == keyRelease = withDisplay $ \dpy -> do
--      s  <- io $ keycodeToKeysym dpy code 0
--      io $ hPutStrLn stderr . show $ code
--      return (All True)

dummyEventHook _ = return (All True)


{- TODO: improve this

-- Assuming borders of width 1, this causes windows to expand in size by 1
-- pixel all around. This makes borders fall off the edge of the screen, which
-- I want. (Why waste a pixel to indicate a window border at the edge of the
-- screen? Also this causes burn-in on my LCD.) It's not the optimal "line
-- between, not around windws" algorithm that I want, but it's close enough.

data MyResizeScreen a = MyResizeScreen deriving (Read, Show)

instance LayoutModifier MyResizeScreen a where
    modifyLayout _ ws r@(Rectangle x y w h) = runLayout ws $ Rectangle (x-1) (y-1) (w+3) (h+3)
-}

-- vim: set et:
