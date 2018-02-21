
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}

module Repositories.SqliteDb(initDb) where

import qualified Data.Text.IO as TIO
import Database.SQLite.Simple
import Text.RawString.QQ
import Control.Monad.Reader

import Utilities.SqliteDb



type SqliteM a = ReaderT Connection IO a

initSql = [r| 

PRAGMA foreign_keys=ON;

PRAGMA foreign_key_check;

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


initDb :: String -> IO ()
initDb db = withConnection db $ \conn -> do
  setTrace conn $ Just TIO.putStrLn 
  execMany ";" conn initSql
