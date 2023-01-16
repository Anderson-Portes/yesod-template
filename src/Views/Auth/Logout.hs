{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Unused LANGUAGE pragma" #-}
module Views.Auth.Logout where

import Data.Text
import Foundation
import Yesod
import Yesod.Core

postLogoutR :: Handler Html
postLogoutR = pageNeedAuth $ do
  deleteSession "login"
  redirect LoginR