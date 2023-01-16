{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use fewer LANGUAGE pragmas" #-}
{-# HLINT ignore "Unused LANGUAGE pragma" #-}

module Requests.Auth.Register where

import Data.Aeson.Types
import Data.Text

data RegisterRequest = RegisterRequest {getName :: Text, getEmail :: Text, getPassword :: Text, getPasswordConfirmation :: Text}

instance FromJSON RegisterRequest where
  parseJSON = withObject "Register" $ \v -> RegisterRequest <$> v .: "name" <*> v .: "email" <*> v .: "password" <*> v .: "password_confirmation"