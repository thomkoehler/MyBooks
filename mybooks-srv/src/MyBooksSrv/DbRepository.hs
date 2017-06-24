
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.DbRepository
(
  getAllPersons,
  getAllBooks,
  importData,
  runSqliteDb
) 
where

import Control.Monad
import Control.Monad.Logger
import Control.Monad.Trans.Reader
import Database.Persist.Sqlite

import MyBooksSrv.DbModels
import MyBooksSrv.Config
import MyBooksSrv.ImportData


type DbAction a = ReaderT SqlBackend (LoggingT IO) a

runSqliteDb :: Config -> DbAction a -> IO a
runSqliteDb config action = do
  runStderrLoggingT $ withSqliteConn (database config) $ \sqlbackend -> runSqlConn action sqlbackend

{-
test :: IO ()
test =
   runStderrLoggingT $ withSqliteConn ":memory:" $ \sqlbackend -> do
     --void $ runSqlConn (insert $ Foo 1) sqlbackend
     --liftIO $ threadDelay (60 * 1000000)
     runSqlConn (runMigration migrateAll) sqlbackend
     ret <- runSqlConn getAllPersons sqlbackend
     return ()
     
getAllPersons :: ReaderT SqlBackend (LoggingT IO) [Person]
getAllPersons = do
  ps <- selectList [] []
  return $ (map (\(Entity _ r) -> r) ps :: [Person])

-}
  
  
getAllPersons :: Config -> IO [Person]
getAllPersons config = runSqliteDb config $ do
  ps <- selectList [] []
  return $ (map (\(Entity _ r) -> r) ps :: [Person])
  

getAllBooks :: Config -> IO [Book]
getAllBooks config = runSqliteDb config $ do
  bs <- selectList [] []
  return $ map (\(Entity _ r) -> r) bs

  
importData :: ImportData -> Config -> IO ()
importData impData config = runSqliteDb config $ do
  forM_ (authors impData) importAuthor
 
 
importAuthor :: ImportAuthor -> DbAction ()
importAuthor a = do
  let 
    p = author a
    n = personName p
  ps <- selectList [PersonName ==. n] [LimitTo 1]
  personKey <- case ps of
    [Entity k _] -> return k
    _ -> insert p

  forM_ (books a) (importBook personKey)


importBook :: Key Person -> ImportBook -> DbAction ()
importBook authorId (ImportBook t i) = do
  bs <- selectList [BookTitle ==. t] [LimitTo 1]
  when (null bs) $ insert (Book t i authorId) >> return ()
