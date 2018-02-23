
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Repositories.SqliteDb
(
  SqliteM, 
  runSqliteM,
  initDb
) 
where

import Control.Monad.IO.Class
import Control.Monad.Reader
import Text.RawString.QQ

import Repositories.SqliteM
import Repositories.DefaultDataRepository
import MyBooksSrv.Config
import Utilities.File
import Utilities.SqliteDb

  
initSql :: String
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

initDb :: Config -> IO ()
initDb cfg = runSqliteM cfg $ do
  conn <- ask
  liftIO $ execMany ";" conn initSql
  let defDataFileName = defaultData cfg
  when (not (null defDataFileName)) $ do
    defData <- liftIO $ loadFromFile defDataFileName
    importDefaultData defData 
