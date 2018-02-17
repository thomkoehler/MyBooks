
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.BookRepository
(
  getBookList,
  getBook,
  insertBook
) where

import Data.Text(Text)
import Database.Persist.Sql

import MyBooksSrv.DomainModels
import MyBooksSrv.DbModels
import MyBooksSrv.DbRepository
import MyBooksSrv.Config


getBookList :: Config -> IO [BookListItem]
getBookList config = runSqliteDb config $ do
  rawList :: [(BookId, Single Text)] <- rawSql "SELECT id, title FROM book" []
  return $ map (\(i, t) -> BookListItem i (unSingle t)) rawList


getBook :: Config -> BookId -> IO (Maybe Book)
getBook config bookId = runSqliteDb config $ do
  ps <- selectList [BookId ==. bookId] [LimitTo 1]
  case ps of
    Entity _ p : _ -> return $ Just p
    _ -> return Nothing


insertBook :: Config -> Book -> IO BookId
insertBook config = runSqliteDb config . insert

