
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}

module MyBooksSrv.FieldDataType where

import Data.Aeson
import Database.Persist.TH
import GHC.Generics


data FieldDataType
  = SingleLnText
  | MultiLnText
  deriving (Show, Read, Eq, Generic)

instance ToJSON FieldDataType where
   toEncoding = genericToEncoding defaultOptions

instance FromJSON FieldDataType


derivePersistField "FieldDataType"