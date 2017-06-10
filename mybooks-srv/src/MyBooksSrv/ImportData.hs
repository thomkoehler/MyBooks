
{-# LANGUAGE DeriveGeneric #-}

module MyBooksSrv.ImportData where

import Data.Aeson
import GHC.Generics
import Data.Text

import MyBooksSrv.DbModels


data ImportData = ImportData
  {
    authors :: [ImportAuthor]
  }
  deriving(Generic, Show)

instance ToJSON ImportData where
   toEncoding = genericToEncoding defaultOptions
   
instance FromJSON ImportData


data ImportAuthor = ImportAuthor
  {
    author :: Person,
    books :: [ImportBook]
  }
  deriving(Generic, Show)
  
instance ToJSON ImportAuthor where
   toEncoding = genericToEncoding defaultOptions
   
instance FromJSON ImportAuthor


data ImportBook = ImportBook
  {
    title :: Text,
    isbn13 :: String
  }
  deriving(Generic, Show)
  
instance ToJSON ImportBook where
   toEncoding = genericToEncoding defaultOptions
   
instance FromJSON ImportBook
