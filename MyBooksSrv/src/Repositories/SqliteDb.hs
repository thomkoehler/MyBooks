
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}

module Repositories.SqliteDb where

import Database.SQLite.Simple
import Text.RawString.QQ
import Control.Monad.Reader


type SqliteM a = ReaderT Connection IO a


initSql = [r| 

CREATE TABLE IF NOT EXISTS Book
(
  Id INTEGER PRIMARY KEY,
  Title TEXT NOT NULL,
  Isbn13 TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Person
(
  Id INTEGER PRIMARY KEY,
  FirstName TEXT,
  LastName TEXT NOT NULL
);

|]

main :: IO ()
main = do
  conn <- open "test.db"
  execute_ conn initSql
  close conn