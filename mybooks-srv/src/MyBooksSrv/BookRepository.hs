
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.BookRepository
(
  getAllBooks
) where

import Data.Text(Text)
import Database.Persist.Sql

import MyBooksSrv.DomainModels
import MyBooksSrv.DbModels
import MyBooksSrv.DbRepository
import MyBooksSrv.Config


getAllBooks :: Config -> IO [Book]
getAllBooks config = runSqliteDb config $ do
  bs <- selectList [] []
  return $ map (\(Entity _ r) -> r) bs

