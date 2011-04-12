{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, PatternGuards #-}

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

-- I wish Haskell imports were explicit, so I could tell which symbols are
-- imported from which libraries. Am I even using all these imports?

import Data.Map hiding (keys)
import Data.Monoid

import XMonad
import XMonad.Operations
import qualified XMonad.StackSet as W

import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Actions.DwmPromote
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

import XMonad.Layout.Combo
import XMonad.Layout.Decoration
import XMonad.Layout.DwmStyle
import XMonad.Layout.IM
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ShowWName
import XMonad.Layout.Spiral
import XMonad.Layout.Simplest
import XMonad.Layout.Tabbed
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.TwoPane
import XMonad.Util.Themes
import XMonad.Prompt.Theme

import Control.Monad
import Graphics.X11.Xlib
import XMonad.Actions.UpdatePointer
import System.IO (hPutStrLn, stderr)
import System.Exit

-- Does the use of 'where' make any difference here?
--      main = x y z
--          where
--              y = foo
--              z = bar
-- vs.
--      main = x y z
--      y = foo
--      z = bar


main :: IO ()
main = xmonad $ ewmh defaultConfig
        { layoutHook         = id           -- 'id' is identity, just for pretty source code
            $ ModifiedLayout MyResizeScreen 
            $ showWName' defaultSWNConfig { swn_font = bigfont }
            -- $ layoutHints
            $ avoidStruts
            -- For some reason I never could get 'onWorkspace' to work well.
            -- $ onWorkspace "chat/music" (IM (320/1680) (Role "buddy_list"))
            -- $ onWorkspace "chat/music" (combineTwo (TwoPane delta (320/1680)) (Mirror tiled) (Full))
            $ decorateWindows
            $ spiral (1050/1680) ||| tiled ||| Mirror tiled ||| Full
        , keys               = keys'
        , manageHook         = manageHook' <+> manageDocks <+> manageHook defaultConfig
        , logHook            = updatePointer (Relative 0.5 0.5)
        , terminal           = "x-terminal-emulator"
        , borderWidth        = 1
        , normalBorderColor  = inactiveBorderColor myTheme --"#666666"
        , focusedBorderColor = activeBorderColor myTheme --"#d78d07"
        , workspaces         = workspaces'
        , handleEventHook    = eventHook'
        , startupHook        = ewmhDesktopsStartup >> setWMName "LG3D"
        }


-- Configuration settings used to override the defaultConfig, above.
myTheme       = theme $ listOfThemes!!2     -- I like the second theme in the list.
floatClasses  = ["display", "Xwud"]         -- These windows always float by default
ignoreClasses = ["Audacious"]
tiled         = Tall nmaster delta ratio
nmaster       = 1
delta         = 64/1680              -- adjust 64 pixels at a time on my 1680px wide monitor
ratio         = (1680-640)/1680      -- main takes all but 640 pixels on my 1680px wide monitor
bigfont       = "-*-new century schoolbook-*-r-*-*-34-*-*-*-*-*-*-*"
workspaces'   = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]


manageHook'   = composeAll [ className =? c --> doFloat  | c <- floatClasses ] <+>
                composeAll [ className =? c --> doIgnore | c <- ignoreClasses ]


-- Sometimes I like dwmStyle, sometimes I like tabBar. Both have warts that I'd
-- like to fix, and I pick whichever is less anoyying. TODO
decorateWindows = id
    $ dwmStyle shrinkText myTheme
    -- $ tabBar shrinkText myTheme Bottom . resizeVerticalBottom (fromIntegral (decoHeight myTheme))


-- Keybindings: some attempts to specify keybindings in a uniform, declaritive,
-- boilerplate-free way. To add or replace a keybinding, add a Map item to Just
-- an X action. To remove, add a Map item to Nothing.
keys' :: XConfig Layout -> Map (KeyMask, KeySym) (X ())
keys' x = union addkeys $ origkeys \\ delkeys
    where
        origkeys = keys defaultConfig x
        (delkeys, addkeys) = mapEither partitioner $ mykeys $ modMask x

-- Used by keys' to take apart the Just/Nothing dichotomy.
partitioner :: Maybe a -> Either (X ()) a
partitioner (Nothing) = Left $ return ()
partitioner (Just y)  = Right $ y

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
                , (f  , m ) <- [(W.greedyView, noMask), (W.shift, shiftMask)]
            ]
            ++
            -- Assign screens to keys z/x/c: use mod to view, mod+shift to send
            [ (m, key, screenWorkspace sc >>= flip whenJust (windows . f))
                | (key, sc) <- zip ["z", "x", "c"] [0..]
                , (f  , m ) <- [(W.view, noMask), (W.shift, shiftMask)]
            ]
            ++
            -- Misc. other bindings
            [ (noMask      , "b"      , spawn "sensible-browser") -- "browser"
            , (noMask      , "r"      , shellPrompt (themedXPConfig myTheme)) -- "run"
            , (noMask      , "F11"    , sendMessage ToggleStruts) -- "border"
            , (noMask      , "Return" , dwmpromote)
            , (controlMask , "t"      , themePrompt (themedXPConfig myTheme))
            , (shiftMask   , "F10"    , io (exitWith ExitSuccess)) -- %! Quit xmonad
            , (noMask      , "F10"    , restart "xmonad" True) -- %! Restart xmonad
            , (controlMask , "k"      , kill)
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
themedXPConfig t = defaultXPConfig 
        { font              = fontName t
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
-- names, current desktop name, window list, and graphical desktop summary
-- appear. When released the information disappears.
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
    dummyEventHook e

--dummyEventHook :: Event -> X All
--dummyEventHook KeyEvent {ev_event_type = t, ev_state = m, ev_keycode = code}
--  | t == keyRelease = withDisplay $ \dpy -> do
--      s  <- io $ keycodeToKeysym dpy code 0
--      io $ hPutStrLn stderr . show $ code
--      return (All True)

dummyEventHook _ = return (All True)


-- Assuming borders of width 1, this causes windows to expand in size by 1
-- pixel all around. This makes borders fall off the edge of the screen, which
-- I want. (Why waste a pixel to indicate a window border at the edge of the
-- screen? Also this causes burn-in on my LCD.) It's not the optimal "line
-- between, not around windws" algorithm that I want, but it's close enough.

data MyResizeScreen a = MyResizeScreen deriving (Read, Show)

instance LayoutModifier MyResizeScreen a where
    modifyLayout _ ws r@(Rectangle x y w h) = runLayout ws $ Rectangle (x-1) (y-1) (w+3) (h+3)

-- vim: set et:
