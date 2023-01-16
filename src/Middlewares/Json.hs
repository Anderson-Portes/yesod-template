{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module Middlewares.Json where

import Data.Aeson (Value)
import Foundation (Auth (Authenticated, Unanthenticated), Handler, userIsLogged)
import Utils.Global (jsonErrors)

{-# HLINT ignore "Use fewer LANGUAGE pragmas" #-}
{-# HLINT ignore "Unused LANGUAGE pragma" #-}

renderJsonByAuthState :: Auth -> Handler Value -> Handler Value
renderJsonByAuthState needAuth f = do
  isLogged <- userIsLogged
  let msg = if needAuth == Authenticated then "You need to be authenticated" else "You are already authenticated"
  if needAuth == isLogged
    then f
    else jsonErrors [msg]

jsonNeedAuth :: Handler Value -> Handler Value
jsonNeedAuth = renderJsonByAuthState Authenticated

jsonNeedGuest :: Handler Value -> Handler Value
jsonNeedGuest = renderJsonByAuthState Unanthenticated