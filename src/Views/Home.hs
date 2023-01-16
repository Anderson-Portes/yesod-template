{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Views.Home where

import Foundation
import Middlewares.Pages (pageNeedAuth)
import Yesod.Core

getHomeR :: Handler Html
getHomeR = pageNeedAuth $ do
  [whamlet|
    <p>Hello World
  |]
