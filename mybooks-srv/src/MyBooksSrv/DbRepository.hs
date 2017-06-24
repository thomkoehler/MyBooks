
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
runSqliteDb config action = 
  runStderrLoggingT $ withSqliteConn (database config) $ \sqlbackend -> runSqlConn action sqlbackend

  
getAllPersons :: Config -> IO [Person]
getAllPersons config = runSqliteDb config $ do
  ps <- selectList [] []
  return $ map (\(Entity _ r) -> r) ps
  

getAllBooks :: Config -> IO [Book]
getAllBooks config = runSqliteDb config $ do
  bs <- selectList [] []
  return $ map (\(Entity _ r) -> r) bs

  
importData :: ImportData -> Config -> IO ()
importData impData config = runSqliteDb config $ forM_ (authors impData) importAuthor
 
 
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
  when (null bs) $ void $ insert (Book t i authorId)
