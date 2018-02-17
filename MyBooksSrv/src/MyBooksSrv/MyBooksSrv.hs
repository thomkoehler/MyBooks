
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}

module MyBooksSrv(runWithDB) where

import Yesod

import Repositories.PersonRepository


data MyBooksSrv = MyBooksSrv Config


mkYesod "MyBooksSrv" [parseRoutes|
|]


instance Yesod MyBooksSrv



runWithDB :: IO ()
runWithDB = do
  cfg <- loadFromFile "config.json"
  runSqliteDb cfg (runMigration migrateAll)
  defData <- loadFromFile "defaultData.json"
  importData defData cfg
  warp (srvPort cfg) (MyBooksSrv cfg)
