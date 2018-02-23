
{-# LANGUAGE TemplateHaskell #-}

module MyBooksSrv.Config where

import Data.Aeson
import Data.Aeson.TH

data Config = Config
  {
    database :: String,
    srvPort :: Int,
    defaultData :: String
  }

deriveJSON defaultOptions ''Config
