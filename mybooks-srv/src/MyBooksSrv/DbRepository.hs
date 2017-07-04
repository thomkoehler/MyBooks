
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}


module MyBooksSrv.DbRepository
(
  importData,
  runSqliteDb,
)
where

import Control.Monad
import Control.Monad.Logger
import Control.Monad.Trans.Reader
import Database.Persist.Sqlite
import Database.Persist.Sql
import Data.Text(Text)
import Text.Printf

import MyBooksSrv.DbModels
import MyBooksSrv.Config
import MyBooksSrv.ImportData
import MyBooksSrv.DomainModels


type DbAction a = ReaderT SqlBackend (LoggingT IO) a


runSqliteDb :: Config -> DbAction a -> IO a
runSqliteDb config action = 
  runStderrLoggingT $ withSqliteConn (database config) $ \sqlbackend -> runSqlConn action sqlbackend


importData :: ImportData -> Config -> IO ()
importData (ImportData bs ps) config = runSqliteDb config $ do
  forM_ bs importBook
  forM_ ps importPerson


importBook :: Book -> DbAction ()
importBook bk = do
  bs <- selectList [BookTitle ==. bookTitle bk] [LimitTo 1]
  when (null bs) $ void $ insert bk
  return ()

  
importPerson :: ImportPerson -> DbAction ()
importPerson (ImportPerson p bs) = do
  ps <- selectList [PersonFirstName ==. personFirstName p, PersonLastName ==. personLastName p] [LimitTo 1]
  personKey <- case ps of
    [Entity k _] -> return k
    _ -> insert p
  forM_ bs $ insertBookAuthor personKey
  return ()

  
insertBookAuthor :: Key Person -> String -> DbAction ()
insertBookAuthor personKey bookIsbn13 = do
  bs <- selectList [BookIsbn13 ==. bookIsbn13] [LimitTo 1]
  case bs of
    [Entity bookKey _] -> do
      bas <- selectList [BookAuthorBookId ==. bookKey, BookAuthorPersonId ==. personKey] [LimitTo 1]
      case bas of
        [] -> void $ insert $ BookAuthor bookKey personKey
        _ -> return ()
    _ -> error $ printf "Error: Book '%s' not found." bookIsbn13
