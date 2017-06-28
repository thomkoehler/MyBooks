
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


instance Eq BookListItem where
  left == right = (title left) == (title right)


instance Ord BookListItem where
  compare left right = compare (title left) (title right)


data PersonListItem = PersonListItem
  {
    id :: PersonId,
    firstName :: Text,
    lastName :: Text
  }
  deriving(Generic, Show)

instance ToJSON PersonListItem where
   toEncoding = genericToEncoding defaultOptions

instance FromJSON PersonListItem


instance Eq PersonListItem where
  left == right = (firstName left) == (firstName right) && (lastName left) == (lastName right)

instance Ord PersonListItem where
  compare left right =
    let
      lastNameCompare = compare (lastName left) (lastName right)
    in
      if lastNameCompare == EQ then compare (firstName left) (firstName right) else lastNameCompare