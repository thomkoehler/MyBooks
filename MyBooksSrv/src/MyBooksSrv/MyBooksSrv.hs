
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns #-}
{-# OPTIONS_GHC -fno-warn-unused-top-binds #-}

module MyBooksSrv.MyBooksSrv(runWithDB) where

import Yesod

import Data.Int
import Data.List

import MyBooksSrv.Config
import Utilities.File
import Repositories.SqliteDb
import Repositories.PersonRepository
import DomainModels.Person


data MyBooksSrv = MyBooksSrv Config

runWithDB :: String -> IO ()
runWithDB cfgFileName = do
  cfg <- loadFromFile cfgFileName
  initDb cfg
  warp (srvPort cfg) (MyBooksSrv cfg)


mkYesod "MyBooksSrv" [parseRoutes|
  / HomeR GET
  /person/#Int64 PersonR GET
  /personList  PersonListR GET

  /api/person ApiInsertPersonR PUT
|]


instance Yesod MyBooksSrv

  
getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|
  <h1>MyBooks
  <body>
    <p>
      <a href=@{PersonListR}>Persons
|]

getPersonR :: Int64 -> Handler Value
getPersonR personId = do
  (MyBooksSrv cfg) <- getYesod
  mbp <- liftIO $ getPerson cfg personId
  case mbp of
    Nothing -> notFound
    (Just p) -> returnJson p

    
getPersonListR :: Handler Html
getPersonListR = do
  (MyBooksSrv cfg) <- getYesod
  ps <- liftIO $ getAllPersons cfg
  let sortedPs = sort ps
  defaultLayout [whamlet|
    <h1>PersonList
    <body>
      <ol>
        $forall (Person i ln fn _) <- sortedPs
          <li><a href=@{PersonR i}>#{ln}, #{fn}
|]


putApiInsertPersonR :: Handler Value
putApiInsertPersonR = do
  (MyBooksSrv cfg) <- getYesod
  person <- requireJsonBody :: Handler Person
  key <- liftIO $ insertPerson cfg person
  returnJson key
  
