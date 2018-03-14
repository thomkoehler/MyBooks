
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE FlexibleContexts #-}


module DomainModels.Person where

import Prelude hiding(id)
import Data.Text(Text)
import Data.Int
import Data.Aeson
import Data.Aeson.TH

import Utilities.Ordering


data Person = Person
  {
    id :: Int64,
    firstName :: Text,
    lastName :: Text,
    description :: Text
  }
  deriving Eq

deriveJSON defaultOptions ''Person

instance Ord Person where
  compare = comparing3 lastName firstName id