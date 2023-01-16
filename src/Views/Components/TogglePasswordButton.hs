{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Views.Components.TogglePasswordButton where

import Foundation (Route (StaticR), Widget, js_show_password_js)
import Yesod (julius, whamlet)

togglePasswordButton :: Widget
togglePasswordButton = do
  [whamlet|
  <button type=button #toggle-password-btn .btn.btn-sm.btn-outline-dark>
    <i .bi.bi-eye-fill>
  <script src=@{StaticR js_show_password_js}>
  |]