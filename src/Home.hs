{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Home where

import Foundation
import Yesod.Core

getHomeR :: Handler Html
getHomeR = pageNeedAuth $ do
  [whamlet|
    <p>Hello World
  |]
