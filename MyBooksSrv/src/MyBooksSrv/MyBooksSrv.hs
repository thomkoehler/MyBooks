
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -fno-warn-unused-top-binds #-}

module MyBooksSrv.MyBooksSrv(runWithDB) where

import Yesod

import MyBooksSrv.Config
import Repositories.PersonRepository
import Utilities.File
import Repositories.SqliteDb


data MyBooksSrv = MyBooksSrv Config


mkYesod "MyBooksSrv" [parseRoutes|
  / HomeR GET
  /personList  PersonListR GET
|]


instance Yesod MyBooksSrv


runWithDB :: IO ()
runWithDB = do
  cfg <- loadFromFile "config.json"
  initDb $ database cfg
  warp (srvPort cfg) (MyBooksSrv cfg)

  
getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|
  <h1>MyBooks
|]


getPersonListR :: Handler Html
getPersonListR = do
  defaultLayout [whamlet|
    <h1>PersonList
|]
