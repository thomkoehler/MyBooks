
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
  liftIO $ putStrLn $ show mongoConf
  withMongoPool mongoConf $ \pool -> runMongoDBPool master action pool


getAllPersons :: Config -> IO [Person]
getAllPersons config = runMongo config $ do
  ps <- selectList [] []
  return $ map (\(Entity _ r) -> r) ps
  
  
importData :: ImportData -> Config -> IO ()
importData importData config = runMongo config $ do
  _forM (authors importData) $ \atr -> do
    let n = name $ author atr
    ps <- selectList [PersonName ==. n] [LimitTo 1]
    case ps of
      [] -> insert atr >> return ()
      otherwise  -> return ()
  return ()

