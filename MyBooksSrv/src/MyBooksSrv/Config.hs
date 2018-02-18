
{-# LANGUAGE TemplateHaskell #-}

module MyBooksSrv.Config where

import Data.Aeson
import Data.Aeson.TH
import Data.Text

data Config = Config
  {
    database :: String,
    srvPort :: Int
  }

deriveJSON defaultOptions ''Config
