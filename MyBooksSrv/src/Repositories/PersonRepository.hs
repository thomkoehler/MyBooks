
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Repositories.PersonRepository
(
  insertPerson,
  insertOrUpdatePerson,
  getPerson,
  getAllPersons
) 
where
  
import Control.Monad.IO.Class
import Data.Int
import Data.Maybe
import Database.SQLite.Simple
import Control.Monad.Reader
  
import DomainModels.Person
import MyBooksSrv.Config
import Repositories.SqliteM
import Utilities.SqliteDb


instance FromRow Person where
  fromRow = Person <$> field <*> field <*> field <*> field


instance ToRow Person where
  toRow (Person _ fn ln desc) = toRow (fn, ln, desc)


insertPerson :: Config -> Person -> IO Int64
insertPerson cfg person = runSqliteM cfg $ insertPerson_ person

insertOrUpdatePerson :: Person -> SqliteM Int64
insertOrUpdatePerson person = do
  mbPersonId <- findPerson_ person
  case mbPersonId of
    (Just personId) -> do
      updatePerson_ person personId
      return personId
    _               -> insertPerson_ person
  
  
getAllPersons :: Config -> IO [Person]
getAllPersons cfg = runSqliteM cfg $ do
  conn <- ask
  liftIO $  query_ conn "SELECT * FROM Person"
 
  
getPerson :: Config -> Int64 -> IO (Maybe Person)
getPerson cfg personId = runSqliteM cfg $ do
  conn <- ask
  ps <- liftIO $ query conn "SELECT * FROM Person WHERE Id = ?" (Only personId)
  return $ listToMaybe ps
 
  
findPerson_ :: Person -> SqliteM (Maybe Int64)
findPerson_ person = do
  conn <- ask
  personIds <- liftIO $ query conn "SELECT id FROM Person WHERE firstName = ? AND lastName = ?" (firstName person, lastName person)
  return $ listToMaybe $ fromOnlies personIds
  
  
updatePerson_ :: Person -> Int64 -> SqliteM ()
updatePerson_ person personId = do
  conn <- ask
  liftIO $ execute conn "UPDATE PERSON SET firstName = ?, lastName = ?, description = ? WHERE id = ?" (firstName person, lastName person, description person, personId)
  
  
insertPerson_ :: Person -> SqliteM Int64
insertPerson_ person = do
  conn <- ask
  liftIO $ execute conn "INSERT INTO Person(firstName, lastName, description) VALUES(?, ?, ?)" (person)
  liftIO $ lastInsertRowId conn
