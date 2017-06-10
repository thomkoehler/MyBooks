
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.MyBooksSrv where

import Control.Monad.IO.Class  (liftIO)
import Control.Monad.Logger    (runStderrLoggingT)
import Database.Persist
import Database.Persist.MongoDB
import Database.Persist.TH
import Database.Persist.Sql
import Yesod
import Data.Aeson


import MyBooksSrv.DbModels
import MyBooksSrv.DbRepository
import MyBooksSrv.Config



data MyBooksSrv = MyBooksSrv
  {
    config :: Config
  }


mkYesod "MyBooksSrv" [parseRoutes|
  / HomeR GET
  /person PersonR GET
|]


instance Yesod MyBooksSrv


getHomeR :: Handler Value
getHomeR = returnJson $ Person "Sabine"

  
getPersonR :: Handler Value
getPersonR = do
  (MyBooksSrv config) <- getYesod
  ps <- liftIO $ getAllPersons config
  returnJson ps


migration = return ()


initMongoDB :: IO ()
initMongoDB = do
  config <- fromFile "config.json"
  let mongoConf = defaultMongoConf $ database config
  withMongoPool mongoConf $ \pool -> do
    flip (runMongoDBPool master) pool migration
  warp (srvPort config) (MyBooksSrv config)

