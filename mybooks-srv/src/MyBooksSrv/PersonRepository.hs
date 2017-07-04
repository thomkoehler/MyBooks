
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.PersonRepository
(
  getPersonList,
  getPerson,
  insertPerson
)
where

import Data.Text(Text)
import Database.Persist.Sql

import MyBooksSrv.DomainModels
import MyBooksSrv.DbModels
import MyBooksSrv.DbRepository
import MyBooksSrv.Config


getPersonList :: Config -> IO [PersonListItem]
getPersonList config = runSqliteDb config $ do
  rawList :: [(PersonId, Single Text, Single Text)] <- rawSql "SELECT id, first_name, last_name FROM person" []
  return $ map (\(i, fn, ln) -> PersonListItem i (unSingle fn) (unSingle ln)) rawList


getPerson :: Config -> PersonId -> IO (Maybe Person)
getPerson config personId = runSqliteDb config $ do
  ps <- selectList [PersonId ==. personId] [LimitTo 1]
  case ps of
    ((Entity _ p):_) -> return $ Just p
    _ -> return Nothing


insertPerson :: Config -> Person -> IO PersonId
insertPerson config person = runSqliteDb config $ insert person

