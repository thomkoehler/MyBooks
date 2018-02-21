
{-# LANGUAGE TemplateHaskell #-}

module DomainModels.Person where

import Data.Text
import Data.Int
import Data.Aeson
import Data.Aeson.TH


data Person = Person
  {
    id :: Int64,
    firstName :: Text,
    lastName :: Text
  }
  deriving(Eq, Ord)
  
deriveJSON defaultOptions ''Person


  