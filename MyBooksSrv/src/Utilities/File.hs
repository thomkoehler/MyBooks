
module Utilities.File
(
  loadFromFile
) 
where

import Data.Aeson
import qualified Data.ByteString.Lazy as B
import Text.Printf

loadFromFile :: FromJSON a => FilePath -> IO a
loadFromFile path = do
  configTxt <- B.readFile path
  case eitherDecode configTxt of
    Right x -> return x
    Left err -> error $ printf "%s file '%s'" err path
