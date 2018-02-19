
module Utilities.SqliteDb
(
	execMany
) 
where

import Control.Monad
import Database.SQLite.Simple
import Data.List.Split
import Data.String
import Data.Char
import Data.Maybe
import Data.List


isNotEmptyString :: String -> Bool
isNotEmptyString str = isJust $ find (\c -> not (isSpace c)) str


execMany :: String -> Connection -> String -> IO ()
execMany delimiter conn query = do
  let queries = map fromString . filter isNotEmptyString $ splitOn delimiter query
  forM_ queries (execute_ conn)