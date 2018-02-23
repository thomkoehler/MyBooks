
module Repositories.DbError where


import Control.Exception
import Data.Int
import Data.Typeable


data DbError
  = IdNotFoundError { id :: Int64 }
  deriving (Eq, Show, Typeable)
 
  
instance Exception DbError