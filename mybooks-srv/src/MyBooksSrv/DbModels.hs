
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
import Language.Haskell.TH.Syntax
import Database.Persist.MongoDB
import Data.Text


let mongoSettings = (mkPersistSettings (ConT ''MongoContext)) {mpsGeneric = False}
 in share [mkPersist mongoSettings] [persistLowerCase|
Book json
  title Text
  isbn13 String
  authorId PersonId
  deriving Show
  
Person json
  name Text
  deriving Show
|]


