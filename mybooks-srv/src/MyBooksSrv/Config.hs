
{-# LANGUAGE DeriveGeneric #-}

module MyBooksSrv.Config where

import qualified Data.ByteString.Lazy as B
import GHC.Generics
import Data.Aeson
import Data.Word
import Text.Printf


data Config = Config
  {
    mySqlDatabase :: String,
    mySqlHost :: String,
    mySqlPort :: Word16,
    mySqlUser :: String,
    mySqlPassword :: String,
    port :: Int
  }
  deriving (Generic, Show)
  
  
instance ToJSON Config where
   toEncoding = genericToEncoding defaultOptions
   
   
instance FromJSON Config


fromFile :: FilePath -> IO Config
fromFile path = do
  configTxt <- B.readFile path
  case decode configTxt of
    Just config -> return config
    Nothing -> error $ printf "Format error file '%s'" path


