
module DomainModels.Person where

import Data.Text


data Person = Person
  {
    firstName :: Text,
    lastName :: Text
  }