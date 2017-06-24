
{-# LANGUAGE DeriveGeneric #-}

module MyBooksSrv.Config where

import Data.Aeson
import Data.Text
import GHC.Generics


data Config = Config
  {
    database :: !Text,
    srvPort :: !Int
  }
  deriving(Generic, Show)
  
  
instance ToJSON Config where
   toEncoding = genericToEncoding defaultOptions
   
   
instance FromJSON Config

