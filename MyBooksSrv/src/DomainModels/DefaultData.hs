
{-# LANGUAGE TemplateHaskell #-}

module DomainModels.DefaultData where

import Data.Aeson
import Data.Aeson.TH

import DomainModels.PersonImport

data DefaultData = DefaultData
  {
    persons :: [PersonImport]
  }

deriveJSON defaultOptions ''DefaultData