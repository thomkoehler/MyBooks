
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}

module MyBooksSrv.ImportData where

import Data.Aeson
import GHC.Generics
import Data.Text

import MyBooksSrv.DbModels


data ImportData = ImportData
  {
    books :: [Book],
    persons :: [ImportPerson]
  }
  deriving(Generic, Show)

instance ToJSON ImportData where
   toEncoding = genericToEncoding defaultOptions
   
instance FromJSON ImportData


data ImportPerson = ImportPerson
  {
      person :: Person,
      books :: [String]
  }
  deriving(Generic, Show)
  
instance ToJSON ImportPerson where
   toEncoding = genericToEncoding defaultOptions
   
instance FromJSON ImportPerson
