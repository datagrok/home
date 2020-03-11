module MyTheme (myTheme, myXPConfig) where

import XMonad.Util.Themes(theme,listOfThemes)
import XMonad.Layout.Decoration(inactiveBorderColor,activeBorderColor,Theme,inactiveColor,inactiveTextColor,activeTextColor,activeColor,inactiveBorderColor,decoHeight)
import XMonad.Prompt

myTheme       = theme $ listOfThemes!!2     -- I like the second theme in the list.
myXPConfig    = themedXPConfig myTheme

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


