
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.MyBooksSrv where

import Control.Monad.IO.Class
import Control.Monad.Reader
import Database.Persist
import Database.Persist.MongoDB
import Yesod


import MyBooksSrv.DbModels
import MyBooksSrv.DbRepository
import MyBooksSrv.Config
import MyBooksSrv.Utilities


defaultPersons :: [Person]
defaultPersons = 
  [
    Person "Stanislaw Lem",
    Person "Philip K. Dick",
    Person "Dan Simmons",
    Person "Ian Banks"
  ]

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


migration :: Config -> ReaderT MongoContext IO ()
migration cfg = do
  _ <- insert $ defaultPersons !! 0
  return ()


initMongoDB :: IO ()
initMongoDB = do
  cfg <- loadFromFile "config.json"
  defData <- loadFromFile "defaultData.json"
  importData defData cfg
  warp (srvPort cfg) (MyBooksSrv cfg)
