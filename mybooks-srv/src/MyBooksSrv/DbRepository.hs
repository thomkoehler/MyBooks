
{-# LANGUAGE FlexibleContexts #-}

module MyBooksSrv.DbRepository
(
  getAllPersons, 
  importData
) 
where

import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Control
import Database.Persist.MongoDB
import Network (PortID (PortNumber))

import MyBooksSrv.DbModels
import MyBooksSrv.Config
import MyBooksSrv.ImportData


runMongo :: (MonadBaseControl IO m, MonadIO m) => Config -> Action m b -> m b
runMongo config action = do
  let 
    defMongoConf = defaultMongoConf $ database config
    mongoConf = defMongoConf
                  {
                    mgHost = dbHost config,
                    mgPort = PortNumber $ toEnum $ dbPort config,
                    mgAuth = Just $ MongoAuth (dbUser config) $ (dbPassword config)
                  }
  withMongoPool mongoConf $ \pool -> runMongoDBPool master action pool


getAllPersons :: (MonadBaseControl IO m, MonadIO m) => Config -> m [Person]
getAllPersons config = runMongo config $ do
  ps <- selectList [] []
  return $ map (\(Entity _ r) -> r) ps
  
  
importData :: (MonadBaseControl IO m, MonadIO m) => ImportData -> Config -> m ()
importData impData config = runMongo config $ do
  forM_ (authors impData) importAuthor
 
 
importAuthor :: (MonadBaseControl IO m, MonadIO m) => ImportAuthor -> Action m ()
importAuthor a = do
  let 
    p = author a
    n = personName p
  ps <- selectList [PersonName ==. n] [LimitTo 1]
  case ps of
    [] -> insert p >> return ()
    _  -> return ()
