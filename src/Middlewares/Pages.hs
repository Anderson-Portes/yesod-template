{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module Middlewares.Pages where

import Foundation (Auth (Authenticated, Unanthenticated), Handler, Route (HomeR, LoginR), Widget, userIsLogged)
import Yesod (Html, Yesod (defaultLayout), redirect)

{-# HLINT ignore "Use fewer LANGUAGE pragmas" #-}
{-# HLINT ignore "Unused LANGUAGE pragma" #-}

redirectUserByAuthState :: Auth -> Handler Html
redirectUserByAuthState Authenticated = redirect HomeR
redirectUserByAuthState _ = redirect LoginR

renderPageByAuthState :: Auth -> Widget -> Handler Html
renderPageByAuthState needAuth widget = do
  isLogged <- userIsLogged
  if needAuth == isLogged
    then defaultLayout widget
    else redirectUserByAuthState isLogged

pageNeedAuth :: Widget -> Handler Html
pageNeedAuth = renderPageByAuthState Authenticated

pageNeedGuest :: Widget -> Handler Html
pageNeedGuest = renderPageByAuthState Unanthenticated