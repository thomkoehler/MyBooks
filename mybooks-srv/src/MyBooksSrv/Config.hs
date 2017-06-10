
{-# LANGUAGE DeriveGeneric #-}

module MyBooksSrv.Config where

import Data.Aeson
import qualified Data.ByteString.Lazy as B
import Data.Word
import Data.Text
import GHC.Generics
import Text.Printf


data Config = Config
  {
    database :: Text,
    dbHost :: String,
    dbPort :: Word16,
    dbUser :: String,
    dbPassword :: String,
    srvPort :: Int
  }
  deriving(Generic, Show)
  
  
instance ToJSON Config where
   toEncoding = genericToEncoding defaultOptions
   
   
instance FromJSON Config


fromFile :: FilePath -> IO Config
fromFile path = do
  configTxt <- B.readFile path
  case decode configTxt of
    Just config -> return config
    Nothing -> error $ printf "Format error file '%s'" path
