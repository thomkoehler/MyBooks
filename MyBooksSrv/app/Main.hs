module Main where

import System.Environment 
import MyBooksSrv.MyBooksSrv


defaultCfgFileName :: String
defaultCfgFileName = "config.json"


main :: IO ()
main = do
  args <- getArgs
  case args of
    (cfgFileName:_) -> runWithDB cfgFileName
    _               -> runWithDB defaultCfgFileName
  
