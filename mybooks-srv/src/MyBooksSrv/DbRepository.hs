
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.DbRepository(getAllPersons) where

import Data.Pool
import Database.Persist.Sql.Types.Internal
import Database.Persist.MongoDB
import Control.Monad.Logger

import MyBooksSrv.DbModels
import MyBooksSrv.Config



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
  let mongoConf = defaultMongoConf $ database config
  withMongoPool mongoConf $ \pool -> do
    flip (runMongoDBPool master) pool $ do
      ps <- selectList [] []
      return $ map (\(Entity k r) -> r) ps

