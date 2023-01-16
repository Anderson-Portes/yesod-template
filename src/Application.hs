{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Application where

import Foundation
import Views.Auth.Login (getLoginR, postLoginR)
import Views.Auth.Logout (postLogoutR)
import Views.Auth.Register (getRegisterR, postRegisterR)
import Views.Home (getHomeR)
import Yesod.Core

mkYesodDispatch "App" resourcesApp
