
{-# LANGUAGE TemplateHaskell #-}

module DomainModels.PersonImport where

import Data.Aeson
import Data.Aeson.TH

import DomainModels.Person
import DomainModels.Book

data PersonImport = PersonImport
  {
    person :: Person,
    books :: [Book]
  }

deriveJSON defaultOptions ''PersonImport