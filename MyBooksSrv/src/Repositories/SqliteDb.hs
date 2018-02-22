
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Repositories.SqliteDb(initDb) where

import Control.Monad.Reader
import qualified Data.Text.IO as TIO
import Database.SQLite.Simple
import Text.RawString.QQ

import Utilities.SqliteDb



type SqliteM a = ReaderT Connection IO a

initSql = [r|

PRAGMA foreign_keys=ON;

PRAGMA foreign_key_check;

CREATE TABLE IF NOT EXISTS Book
(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  isbn13 TEXT NOT NULL UNIQUE,
  description TEXT
);

CREATE TABLE IF NOT EXISTS Person
(
  id INTEGER PRIMARY KEY,
  firstName TEXT,
  lastName TEXT NOT NULL,
  description TEXT,

  CONSTRAINT ConstraintPersonFirstNameLastName UNIQUE(firstName, lastName)
);

CREATE TABLE IF NOT EXISTS BookAuthor
(
  id INTEGER PRIMARY KEY,
  bookId INTEGER NOT NULL,
  personId INTEGER NOT NULL,

  FOREIGN KEY(bookId) REFERENCES Book(Id)
  FOREIGN KEY(personId) REFERENCES Person(Id)
  CONSTRAINT ConstraintBookAuthorBookIdPersonId UNIQUE(bookId, personId)
);

|]


initDb :: String -> IO ()
initDb db = withConnection db $ \conn -> do
  setTrace conn $ Just TIO.putStrLn
  execMany ";" conn initSql
