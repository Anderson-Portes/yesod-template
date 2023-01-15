{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use fewer LANGUAGE pragmas" #-}
{-# HLINT ignore "Unused LANGUAGE pragma" #-}

module Utils.Global where

import Data.ByteString.Lazy.Char8 as BS
import Data.Digest.Pure.SHA (sha1)
import Data.Text as T
import Foundation
import Yesod

sha1Text :: Text -> Text
sha1Text txt = (T.pack . show) $ sha1 (BS.pack $ show txt)

stringListToText :: [String] -> [Text]
stringListToText = fmap T.pack

jsonErrors :: [String] -> Handler Value
jsonErrors errors = return $ object ["errors" .= stringListToText errors]

jsonSuccess :: String -> Handler Value
jsonSuccess message = return $ object ["success" .= T.pack message]
