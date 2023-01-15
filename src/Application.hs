{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Application where

import Auth.Login (getLoginR, postLoginR)
import Auth.Logout (postLogoutR)
import Auth.Register (getRegisterR, postRegisterR)
import Foundation
import Home
import Yesod.Core

mkYesodDispatch "App" resourcesApp
