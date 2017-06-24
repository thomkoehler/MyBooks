
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}

module MyBooksSrv.DbModels where

import Database.Persist.TH
import Database.Persist.Sqlite
import Data.Text


share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Book json
  title Text
  isbn13 String
  authorId PersonId
  deriving Show
  
Person json
  name Text
  deriving Show
|]

{-

let mongoSettings = (mkPersistSettings (ConT ''MongoContext)) {mpsGeneric = False}
 in share [mkPersist mongoSettings] [persistLowerCase|

Book json
  title Text
  isbn13 String
  deriving Show

Person json
  name Text
  deriving Show

Author json
  book BookId
  person PersonId
  deriving Show

|]



-}

