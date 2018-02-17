
module DomainModels.Book where

import Data.Text
import Data.Int


data Book = Book 
  {
      id :: Int64,
      title :: Text,
      isbn13 :: String
  }
  deriving Show