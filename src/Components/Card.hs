{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Components.Card where

import Data.Text (Text)
import Foundation (Widget)
import Yesod (whamlet)

card :: Text -> Widget -> Widget
card title body = do
  [whamlet|
  <div .card>
    <div .card-header>#{title}
    <div .card-body>
      ^{body}
  |]