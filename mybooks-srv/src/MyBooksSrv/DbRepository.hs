
{-# LANGUAGE FlexibleContexts #-}

module MyBooksSrv.DbRepository(getAllPersons) where

import Control.Monad.IO.Class
import Control.Monad.Trans.Control
import Database.Persist.MongoDB

import MyBooksSrv.DbModels
import MyBooksSrv.Config


runMongo :: (MonadBaseControl IO m, MonadIO m) => Config -> Action m b -> m b
runMongo config action = do
  let mongoConf = defaultMongoConf $ database config
  withMongoPool mongoConf $ \pool -> runMongoDBPool master action pool


getAllPersons :: Config -> IO [Person]
getAllPersons config = runMongo config $ do
  ps <- selectList [] []
  return $ map (\(Entity _ r) -> r) ps
