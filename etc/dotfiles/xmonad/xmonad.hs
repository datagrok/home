{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, PatternGuards #-}
module Main (main) where

-- import qualified Data.Map as M
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
-- import XMonad.Layout.Decoration
import XMonad.Util.Themes
import XMonad.Prompt.Theme

import Control.Monad
import Graphics.X11.Xlib
-- Once: gconftool --type boolean --set /apps/nautilus/preferences/show_desktop false
import XMonad.Actions.UpdatePointer
import System.IO (hPutStrLn, stderr)
import System.Exit


main :: IO ()
main = xmonad $ ewmh defaultConfig
		{ layoutHook		 = id
			$ ModifiedLayout MyResizeScreen 
			$ showWName' defaultSWNConfig { swn_font = bigfont }
			-- $ layoutHints
			$ avoidStruts
			-- $ onWorkspace "chat/music" (IM (320/1680) (Role "buddy_list"))
			-- $ onWorkspace "chat/music" (combineTwo (TwoPane delta (320/1680)) (Mirror tiled) (Full))
			$ dwmStyle shrinkText myTheme
			-- $ tabBar shrinkText myTheme Bottom . resizeVerticalBottom (fromIntegral (decoHeight myTheme))
			$ spiral (1050/1680) ||| tiled ||| Mirror tiled ||| Full
		, keys				 = keys'
		, manageHook		 = manageHook' <+> manageDocks <+> manageHook defaultConfig
		, logHook			 = updatePointer (Relative 0.5 0.5)
		, terminal			 = "x-terminal-emulator"
		, borderWidth		 = 1
		, normalBorderColor  = inactiveBorderColor myTheme--"#666666"
		, focusedBorderColor = activeBorderColor myTheme --"#d78d07"
		, workspaces		 = workspaces'
		, handleEventHook	 = eventHook'
		, startupHook        = ewmhDesktopsStartup >> setWMName "LG3D"
		}
myTheme		  = theme $ listOfThemes!!2
floatClasses  = ["display", "Xwud"]
ignoreClasses = ["Audacious"]
tiled		  = Tall nmaster delta ratio
nmaster		  = 1
delta		  = 64/1680				 -- adjust 64 pixels at a time on my 1680px wide monitor
ratio		  = (1680-640)/1680		 -- main takes all but 640 pixels on my 1680px wide monitor
manageHook'   = composeAll [ className =? c --> doFloat  | c <- floatClasses ] <+>
				composeAll [ className =? c --> doIgnore | c <- ignoreClasses ]
bigfont		  = "-*-new century schoolbook-*-r-*-*-34-*-*-*-*-*-*-*"
workspaces'   = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

partitioner :: Maybe a -> Either (X ()) a
partitioner (Nothing) = Left $ return ()
partitioner (Just y)  = Right $ y

-- Keybindings:
--	 To replace, add a Map item to Just an X action
--	 To remove, add a Map item to Nothing
keys' :: XConfig Layout -> Map (KeyMask, KeySym) (X ())
keys' x		   = union addkeys $ origkeys \\ delkeys
	where
		origkeys = keys defaultConfig x
		(delkeys, addkeys) = mapEither partitioner $ mykeys $ modMask x


mykeys :: KeyMask -> Map (KeyMask, KeySym) (Maybe (X ()))
mykeys mod	  = fromList $
		-- Kill the default bindings for w, e, and r
		[ ((mod .|. mask, stringToKeysym key), Nothing)
			| key <- ["w", "e", "r"]
			, mask <- [noMask, shiftMask]
		]
		++
		[ ((mod .|. mask, stringToKeysym key), Just action) | (mask, key, action) <- 
			-- with key matrix 123/qwe/asd: use mod+key to view, mod+shift+key to send
			[ (m, key, windows $ f sc)
				| (key, sc) <- zip ["1", "2", "3", "q", "w", "e", "a", "s", "d"] workspaces'
				, (f  , m ) <- [(W.greedyView, noMask), (W.shift, shiftMask)]
			]
			++
			-- with keys a, s, and d: use mod+key to view, mod+shift+key to
			-- shift screenWorkspaces
			[ (m, key, screenWorkspace sc >>= flip whenJust (windows . f))
				| (key, sc) <- zip ["z", "x", "c"] [0..]
				, (f  , m ) <- [(W.view, noMask), (W.shift, shiftMask)]
			]
			++
			-- Misc. other bindings
			[ (noMask	   , "b"	  , spawn "sensible-browser") -- "browser"
			, (noMask	   , "r"	  , shellPrompt (themedXPConfig myTheme)) -- "run"
			, (noMask	   , "F11"	  , sendMessage ToggleStruts) -- "border"
			, (noMask	   , "Return" , dwmpromote)
			, (controlMask , "t"	  , themePrompt (themedXPConfig myTheme))
			, (shiftMask   , "F10"	  , io (exitWith ExitSuccess)) -- %! Quit xmonad
			, (noMask	   , "F10"	  , restart "xmonad" True) -- %! Restart xmonad
			, (controlMask , "k"	  , kill)
			]
		]
	where
		noMask = 0

-- Create an XPConfig (a configuration for xprompt) from a theme
themedXPConfig :: Theme -> XPConfig
themedXPConfig t = defaultXPConfig 
		{ font				= fontName t
		, bgColor			= inactiveColor t
		, fgColor			= inactiveTextColor t
		, fgHLight			= activeTextColor t
		, bgHLight			= activeColor t
		, borderColor		= inactiveBorderColor t
		, height			= decoHeight t
		, promptBorderWidth = 1
		, position			= Bottom
		, historySize		= 256
		, defaultText		= []
		, autoComplete		= Nothing
}

-- eventHook' (KeyEvent {ev_event_type = t, ev_state = m, ev_keycode = code})
--	   | t == keyRelease = withDisplay $ \dpy -> do
--		   s  <- io $ keycodeToKeysym dpy code 0
--		   mClean <- cleanMask m
--		   ks <- asks keyActions
--		   userCodeDef True ( io ( hPutStrLn stderr . show ( s ))) --return ()
		-- userCodeDef () $ whenJust (Data.Map.lookup (mClean, s) ks) id
-- eventHook' e = io $ hPutStrLn stderr . show $ e --return ()
-- eventHook' _ = return (All True)

eventHook' e = do
	dummyEventHook e


--dummyEventHook :: Event -> X All
--dummyEventHook KeyEvent {ev_event_type = t, ev_state = m, ev_keycode = code}
--	| t == keyRelease = withDisplay $ \dpy -> do
--		s  <- io $ keycodeToKeysym dpy code 0
--		io $ hPutStrLn stderr . show $ code
--		return (All True)

dummyEventHook _ = return (All True)

data MyResizeScreen a = MyResizeScreen deriving (Read, Show)

instance LayoutModifier MyResizeScreen a where
    modifyLayout _ ws r@(Rectangle x y w h) = runLayout ws $ Rectangle (x-1) (y-1) (w+3) (h+3)
