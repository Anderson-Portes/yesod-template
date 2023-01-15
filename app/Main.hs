{-# LANGUAGE OverloadedStrings #-}

import Application ()
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Logger (runStdoutLoggingT)
import Database.Persist.Postgresql
  ( ConnectionString,
    runMigration,
    runSqlPersistMPool,
    withPostgresqlPool,
  )
import Foundation (App (App), migrateAll)
import Yesod.Core (MonadIO (liftIO), warp)
import Yesod.Static (Static (Static), static)

connStr :: ConnectionString
connStr = "dbname=ftp_yesod host=localhost user=postgres password=root port=5432"

main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do
  flip runSqlPersistMPool pool $ do
    runMigration migrateAll
  static@(Static settings) <- static "static"
  warp 4500 (App pool static)