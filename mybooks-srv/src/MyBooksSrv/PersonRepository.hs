
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}

module MyBooksSrv.PersonRepository
(
  getPersonList,
  getPerson,
  insertPerson,
  setPersonHashtag
)
where

import Data.Text(Text)
import Database.Persist.Sql
import Control.Monad

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
    Entity _ p : _ -> return $ Just p
    _ -> return Nothing


insertPerson :: Config -> Person -> IO PersonId
insertPerson config = runSqliteDb config . insert



{- TODO
getPersonHashtags :: Config -> PersonId -> IO [Text]
getPersonHashtags config personId = runSqliteDb config $ do
   hps <- selectList [PersonHashtagPersonId ==. personId] []
   let hashtagIds = map (\(Entity k _) -> k) hps
   forM hashtagIds $ \hashtagId -> do
      hts <- selectList [Hashtagid ==. hashtagId] [LimitTo 1]
      case hts of
-}


setPersonHashtag :: Config -> PersonId -> Text -> IO ()
setPersonHashtag config personId hashtag = do
   hashtagId <- getOrCreateHashtag config hashtag
   runSqliteDb config $ do
      phs <- selectList [PersonHashtagPersonId ==. personId, PersonHashtagHashtagId ==. hashtagId] [LimitTo 1]
      case phs of
         [] -> void $ insert $ PersonHashtag personId hashtagId
         _  -> return ()
