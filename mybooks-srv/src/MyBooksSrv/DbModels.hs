
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
  UniqueIsbn13 isbn13
  deriving Show

Person json
  firstName Text
  lastName Text
  UniqueFirstNameLastName firstName lastName
  deriving Show

BookAuthor json
  bookId BookId
  personId PersonId
  UniqueBookIdPersonId bookId personId
  deriving Show
  
|]
