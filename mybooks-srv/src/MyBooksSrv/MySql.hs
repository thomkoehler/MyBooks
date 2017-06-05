
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module MyBooksSrv.MySql(initMySql) where

import Control.Monad.IO.Class  (liftIO)
import Control.Monad.Logger    (runStderrLoggingT)
import Database.Persist
import Database.Persist.MySQL
import Database.Persist.TH
import Yesod
import Database.Persist.MySQL
import Data.Aeson

import MyBooksSrv.DbModels
import MyBooksSrv.Config
import MyBooksSrv.MyBooksSrv



initMySql :: IO ()
initMySql = do
  config <- fromFile "config.json"
  let connectionInfo = defaultConnectInfo
                        { 
                          connectPort = mySqlPort config,
                          connectPassword = mySqlPassword config,
                          connectDatabase = mySqlDatabase config
                        }
  
  runStderrLoggingT $ withMySQLPool connectionInfo 10 $ \pool -> liftIO $ do
    flip runSqlPersistMPool pool $ do
      printMigration migrateAll
      runMigration migrateAll
      
    warp (port config) MyBooksSrv
      
