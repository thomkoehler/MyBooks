
module Repositories.DefaultDataRepository
(
  importDefaultData
)
where

import Control.Monad


import Repositories.SqliteM
import Repositories.PersonRepository
import DomainModels.DefaultData
import DomainModels.PersonImport


importDefaultData :: DefaultData -> SqliteM ()
importDefaultData defData = do
  let ps = map person $ persons defData
  forM_ ps insertOrUpdatePerson