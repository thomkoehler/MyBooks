
{-# LANGUAGE TemplateHaskell #-}

module DomainModels.Book where

import Data.Text
import Data.Int
import Data.Aeson
import Data.Aeson.TH


data Book = Book 
  {
      id :: Int64,
      title :: Text,
      isbn13 :: String
  }

deriveJSON defaultOptions ''Book