
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.MyBooksSrv where

import Yesod
import Database.Persist.MySQL

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

