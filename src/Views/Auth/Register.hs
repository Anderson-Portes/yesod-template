{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use fewer LANGUAGE pragmas" #-}
{-# HLINT ignore "Unused LANGUAGE pragma" #-}

module Views.Auth.Register where

import Data.Text
import Foundation
import Middlewares.Json (jsonNeedGuest)
import Middlewares.Pages (pageNeedGuest)
import Requests.Auth.Register (RegisterRequest (RegisterRequest, getEmail, getName, getPassword, getPasswordConfirmation))
import Utils.Global (jsonErrors, jsonSuccess, sha1Text, stringListToText)
import Views.Components.Card (card)
import Views.Components.TogglePasswordButton (togglePasswordButton)
import Yesod
import Yesod.Core

registerForm :: Widget
registerForm = card "Register" $ do
  [whamlet|
  <form .was-validated action=@{RegisterR} method=POST #page-form redirect-to=@{HomeR}>
    <div .form-floating.mb-2>
      <input type=text name=name .form-control #name placeholder=Name required>
      <label for=name>Name
    <div .form-floating.mb-2>
      <input type=email name=email .form-control #email placeholder=Email required>
      <label for=email>Email
    <div .form-floating.mb-2>
      <input type=password name=password .form-control #password placeholder=Password required>
      <label for=password>Password
    <div .form-floating.mb-2>
      <input type=password name=password_confirmation .form-control #password_confirmation placeholder=Password required min=8>
      <label for=password_confirmation>Password Confirmation
    <div .text-end.w-100>
      ^{togglePasswordButton}
    <p .text-danger #error-msg>
    <button .btn.btn-sm.btn-outline-primary>
      <i .bi.bi-box-arrow-in-right.me-2>
      Register
  |]

getRegisterR :: Handler Html
getRegisterR = pageNeedGuest $ do
  [whamlet|
  <div .row.justify-content-center>
    <div .col-11.col-md-8.p-0>
      ^{registerForm}
  |]

postRegisterR :: Handler Value
postRegisterR = jsonNeedGuest $ do
  request <- requireCheckJsonBody :: Handler RegisterRequest
  let name = getName request
  let email = getEmail request
  let password = getPassword request
  let passwordConfirm = getPasswordConfirmation request
  userExists <- runDB $ getBy (UniqueEmail email)
  case userExists of
    Nothing ->
      if password == passwordConfirm
        then handleRegister name email password
        else jsonErrors ["Passwords must be the same!"]
    _ -> jsonErrors ["User already exists!"]

handleRegister :: Text -> Text -> Text -> Handler Value
handleRegister name email password = do
  runDB $ insert (User name email False True (sha1Text password))
  jsonSuccess "Valid Register!"