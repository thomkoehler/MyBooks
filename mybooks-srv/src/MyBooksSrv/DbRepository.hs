
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.DbRepository where

import Data.Pool
import Database.Persist.MySQL
import Database.Persist.Sql.Types.Internal
import Control.Monad.Logger

import MyBooksSrv.DbModels
import MyBooksSrv.Config


type ConnPool = Pool SqlBackend


defaultPersons :: [Person]
defaultPersons = 
  [
    Person "Stanislaw Lem",
    Person "Philip K. Dick",
    Person "Dan Simmons",
    Person "Ian Banks"
  ]


getAllPersons :: Config -> IO [Person]
getAllPersons config = do
  let connectionInfo = defaultConnectInfo
                        { 
                          connectPort = mySqlPort config,
                          connectPassword = mySqlPassword config,
                          connectDatabase = mySqlDatabase config
                        }
  withMySQLConn connectionInfo getAllPersons'

  
getAllPersons' :: SqlBackend -> IO [Person]
getAllPersons' _ = return []


