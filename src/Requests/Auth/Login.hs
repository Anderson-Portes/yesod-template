{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use fewer LANGUAGE pragmas" #-}
{-# HLINT ignore "Unused LANGUAGE pragma" #-}

module Requests.Auth.Login where

import Data.Aeson.Types
import Data.Text

data LoginRequest = LoginRequest {getEmail :: Text, getPassword :: Text}

instance FromJSON LoginRequest where
  parseJSON = withObject "Register" $ \v -> LoginRequest <$> v .: "email" <*> v .: "password"