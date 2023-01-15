{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use isJust" #-}

module Foundation where

import Data.Text
import Database.Persist.Postgresql (ConnectionPool, SqlBackend, runSqlPool)
import Yesod
import Yesod.Core
import Yesod.Static (Static, staticFiles)

data Auth = Authenticated | Unanthenticated deriving (Show, Eq)

staticFiles "static"

share
  [mkPersist sqlSettings, mkMigrate "migrateAll"]
  [persistLowerCase|
  User
    name Text
    email Text
    isAdmin Bool
    isActived Bool
    password Text
    UniqueEmail email
    deriving Show
|]

data App = App {connPool :: ConnectionPool, getStatic :: Static}

mkYesodData "App" $(parseRoutesFile "routes.yesodroutes")

userIsLogged :: Handler Auth
userIsLogged = do
  session <- lookupSession "login"
  return (if session /= Nothing then Authenticated else Unanthenticated)

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

renderJsonByAuthState :: Auth -> Handler Value -> Handler Value
renderJsonByAuthState needAuth f = do
  isLogged <- userIsLogged
  let msg = if needAuth == Authenticated then "You need to be authenticated" else "You are already authenticated"
  if needAuth == isLogged
    then f
    else return $ object ["error" .= pack msg]

navbar :: Bool -> Widget
navbar isLogged =
  [whamlet|
  <nav .navbar.navbar-expand-lg.border-bottom.shadow-sm>
    <div .container>
      <a .navbar-brand href=@{HomeR}>Yesod App
      <button .navbar-toggler type=button data-bs-toggle=collapse data-bs-target=#navbarNav aria-controls=navbarNav aria-expanded=false aria-label="Toggle navigation">
        <span .navbar-toggler-icon>
      <div .collapse.navbar-collapse.justify-content-end #navbarNav>
        <ul .navbar-nav>
          $if isLogged
            <li .nav-item.dropdown>
              <a .nav-link.dropdown-toggle href=# role=button data-bs-toggle=dropdown aria-expanded=false>
                <i .bi.bi-person-circle>
              <ul .dropdown-menu>
                <li>
                  <a .dropdown-item>
                    <i .bi.bi-gear.me-2>
                    Settings
                <li>
                    <hr .dropdown-divider>
                <li>
                  <form action=@{LogoutR} method=POST>
                    <button .dropdown-item.text-danger>
                      <i .bi.bi-box-arrow-left.me-2>
                      Sair
          $else
            <li .nav-item>
              <a .nav-link href=@{RegisterR}>Register
            <li .nav-item>
              <a .nav-link href=@{LoginR}>Login
  |]

baseLayout :: Widget -> Handler Html
baseLayout widget = do
  isLogged <- userIsLogged
  pc <- widgetToPageContent widget
  nav <- widgetToPageContent $ navbar (isLogged == Authenticated)
  withUrlRenderer
    [hamlet|
    $doctype 5
    <html>
      <head>
        <head>
          <meta name=viewport content=width=device-width,initial-scale=1.0>
          <meta charset=utf-8>
          <title>Yesod App
          <link rel=stylesheet href=@{StaticR css_bootstrap_min_css}>
          <link rel=stylesheet href=https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css>
          <link rel=stylesheet href=@{StaticR css_custom_css}>
        <body>
          ^{pageBody nav}
          <div .container.py-4>
            ^{pageBody pc}
          <script src=@{StaticR js_bootstrap_bundle_min_js}>
          <script src=@{StaticR js_ajax_form_js}>
    |]

instance Yesod App where
  defaultLayout = baseLayout
  makeSessionBackend _ = Just <$> defaultClientSessionBackend (24 * 60 * 7) "client_session_key.aes"

instance RenderMessage App FormMessage where
  renderMessage _ _ = defaultFormMessage

instance YesodPersist App where
  type YesodPersistBackend App = SqlBackend
  runDB f = do
    master <- getYesod
    let pool = connPool master
    runSqlPool f pool