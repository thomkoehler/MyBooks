
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE RankNTypes #-}


module DomainModels.Person where

import Data.Text(Text)
import Data.Int
import Data.List
import Data.Aeson
import Data.Aeson.TH


data Person = Person
  {
    id :: Int64,
    firstName :: Text,
    lastName :: Text,
    description :: Text
  }
  deriving(Eq)
  
  
instance Ord Person where
  compare = multiComparing [OrdSelector firstName, OrdSelector lastName, OrdSelector DomainModels.Person.id]

  
deriveJSON defaultOptions ''Person



newtype OrdSelector a = OrdSelector (forall b. Ord b => a -> b)


multiComparing :: [OrdSelector b] -> b -> b -> Ordering
multiComparing selectors left right = foldl1 compOrdering $ map mapFun selectors
  where
    mapFun (OrdSelector selector) = compare (selector left) (selector right)
    compOrdering EQ x = x
    compOrdering x _ = x
