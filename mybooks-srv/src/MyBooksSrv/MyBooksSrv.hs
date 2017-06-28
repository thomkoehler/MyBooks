
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns      #-}

module MyBooksSrv.MyBooksSrv(runWithMongoDB) where

import Control.Monad.IO.Class
import Database.Persist.Sql
import Data.List
import Data.Int
import Yesod

import MyBooksSrv.DbModels
import MyBooksSrv.DbRepository
import MyBooksSrv.Config
import MyBooksSrv.Utilities
import MyBooksSrv.DomainModels


data MyBooksSrv = MyBooksSrv Config


mkYesod "MyBooksSrv" [parseRoutes|

  / HomeR GET
  /personList  PersonListR GET
  /person/#Int64 PersonR GET

  /api/personList ApiPersonListR GET
  /api/person ApiInsertPersonR PUT
  /api/book ApiBookR GET

|]


instance Yesod MyBooksSrv

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|
  <h1>MyBooks
  <body>
    <p>
      <a href=@{PersonListR}>Persons
|]


getPersonListR :: Handler Html
getPersonListR = do
  (MyBooksSrv cfg) <- getYesod
  ps <- liftIO $ getPersonList cfg
  let sortedPs = sort ps
  defaultLayout [whamlet|
    <h1>PersonList
    <body>
      <ol>
        $forall (PersonListItem i fn ln) <- sortedPs
          <li><a href=@{PersonR (fromSqlKey i)}>#{ln}, #{fn}
|]


getPersonR :: Int64 -> Handler Html
getPersonR personId = defaultLayout [whamlet|<h1>Person #{personId}|]


getApiPersonListR :: Handler Value
getApiPersonListR = do
  (MyBooksSrv cfg) <- getYesod
  ps <- liftIO $ getPersonList cfg
  returnJson ps


putApiInsertPersonR :: Handler Value
putApiInsertPersonR = do
  (MyBooksSrv cfg) <- getYesod
  person <- requireJsonBody :: Handler Person
  key <- liftIO $ insertPerson cfg person
  returnJson key
  
  
getApiBookR :: Handler Value
getApiBookR = do
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
