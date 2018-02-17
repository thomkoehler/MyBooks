
module DomainModels.Person where

import Data.Text
import Data.Int


data Person = Person
  {
    id :: Int64,
    firstName :: Text,
    lastName :: Text
  }