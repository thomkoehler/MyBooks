
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}

module MyBooksSrv.DomainModels where

import Data.Aeson
import GHC.Generics
import Data.Text

import MyBooksSrv.DbModels


data BookListItem = BookListItem
  {
    id :: BookId,
    title :: Text
  }
  deriving(Generic, Show)

instance ToJSON BookListItem where
   toEncoding = genericToEncoding defaultOptions

instance FromJSON BookListItem


data PersonListItem = PersonListItem
  {
    id :: PersonId,
    name :: Text
  }
  deriving(Generic, Show)

instance ToJSON PersonListItem where
   toEncoding = genericToEncoding defaultOptions

instance FromJSON PersonListItem
