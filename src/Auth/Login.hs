{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Auth.Login where

import Components.Card
import Data.Text
import Foundation
import Utils.Global (jsonErrors, jsonSuccess, sha1Text)
import Yesod
import Yesod.Core

loginForm :: Widget
loginForm = card "Login" $ do
  [whamlet|
  <form .was-validated action=@{LoginR} method=POST #page-form redirect-to=@{HomeR}>
    <div .form-floating.mb-2>
      <input type=email name=email .form-control #email placeholder=Email required>
      <label for=email>Email
    <div .form-floating.mb-2>
      <input type=password name=password .form-control #password placeholder=Password required>
      <label for=password>Password
    <div .text-end.w-100>
      <button type=button #show-password-btn .btn.btn-sm.btn-outline-primary>
        <i .bi.bi-eye-fill>
    <p .text-danger #error-msg>
    <button .btn.btn-sm.btn-outline-primary>
      <i .bi.bi-box-arrow-in-right.me-2>
      Login
  |]

getLoginR :: Handler Html
getLoginR = pageNeedGuest $ do
  [whamlet|
  <div .row.justify-content-center>
    <div .col-11.col-md-8.p-0>
      ^{loginForm}
  |]

postLoginR :: Handler Value
postLoginR = renderJsonByAuthState Unanthenticated $ do
  email <- runInputPost (ireq textField "email")
  password <- runInputPost (ireq textField "password")
  userExists <- runDB $ getBy (UniqueEmail email)
  case userExists of
    Just (Entity userId userData) -> handleLogin password userData userId
    _ -> jsonErrors ["Invalid Login!"]

handleLogin :: Text -> User -> Key User -> Handler Value
handleLogin password user id = do
  if userPassword user == sha1Text password
    then do
      setSession "login" $ (pack . show) id
      jsonSuccess "Valid Login!"
    else jsonErrors ["Invalid Login!"]