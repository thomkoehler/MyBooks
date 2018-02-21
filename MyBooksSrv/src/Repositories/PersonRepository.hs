
{-# LANGUAGE OverloadedStrings #-}

module Repositories.PersonRepository
(
  insertPerson,
  getPerson,
  getAllPersons
) 
where
  
import qualified Data.Text.IO as TIO
import Data.Int
import Data.Maybe
import Database.SQLite.Simple
  
import Repositories.SqliteDb
import DomainModels.Person
import MyBooksSrv.Config
import Repositories.DbError


instance FromRow Person where
  fromRow = Person <$> field <*> field <*> field


insertPerson :: Config -> Person -> IO Int64
insertPerson cfg person = withConnection (database cfg) $ \conn -> do
  setTrace conn $ Just TIO.putStrLn 
  execute conn "INSERT INTO Person(firstName, lastName) VALUES(?, ?)" (firstName person, lastName person)
  lastInsertRowId conn
  
  
getAllPersons :: Config -> IO [Person]
getAllPersons cfg = withConnection (database cfg) $ \conn -> do
  setTrace conn $ Just TIO.putStrLn
  query_ conn "SELECT * FROM Person"
  
  
getPerson :: Config -> Int64 -> IO (Maybe Person)
getPerson cfg personId = withConnection (database cfg) $ \conn -> do
  setTrace conn $ Just TIO.putStrLn
  ps <- queryNamed conn "SELECT * FROM Person WHERE Id = :id" [":id" := personId]
  return $ listToMaybe ps
  
