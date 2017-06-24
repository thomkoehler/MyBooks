
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.MyBooksSrv(runWithMongoDB) where

import Control.Monad.IO.Class
import Database.Persist.Sql
import Yesod

import MyBooksSrv.DbModels
import MyBooksSrv.DbRepository
import MyBooksSrv.Config
import MyBooksSrv.Utilities


data MyBooksSrv = MyBooksSrv
  {
    config :: Config
  }


mkYesod "MyBooksSrv" [parseRoutes|
  / HomeR GET
  /person PersonR GET
  /book BookR GET
|]


instance Yesod MyBooksSrv


getHomeR :: Handler Value
getHomeR = returnJson $ Person "Sabine"

  
getPersonR :: Handler Value
getPersonR = do
  (MyBooksSrv cfg) <- getYesod
  ps <- liftIO $ getAllPersons cfg
  returnJson ps


getBookR :: Handler Value
getBookR = do
  (MyBooksSrv cfg) <- getYesod
  ps <- liftIO $ getAllBooks cfg
  returnJson ps


runWithMongoDB :: IO ()
runWithMongoDB = do
  cfg <- loadFromFile "config.json"
  runSqliteDb cfg (runMigration migrateAll)
  defData <- loadFromFile "defaultData.json"
  importData defData cfg
  warp (srvPort cfg) (MyBooksSrv cfg)
