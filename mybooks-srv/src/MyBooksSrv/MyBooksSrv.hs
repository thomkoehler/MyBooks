
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.MyBooksSrv where

import Control.Monad.IO.Class
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
|]


instance Yesod MyBooksSrv


getHomeR :: Handler Value
getHomeR = returnJson $ Person "Sabine"

  
getPersonR :: Handler Value
getPersonR = do
  (MyBooksSrv cfg) <- getYesod
  ps <- liftIO $ getAllPersons cfg
  returnJson ps


initMongoDB :: IO ()
initMongoDB = do
  cfg <- loadFromFile "config.json"
  defData <- loadFromFile "defaultData.json"
  importData defData cfg
  warp (srvPort cfg) (MyBooksSrv cfg)
