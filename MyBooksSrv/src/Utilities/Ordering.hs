
module Utilities.Ordering(comparing2, comparing3) where

import Data.Ord


comparing2 :: (Ord a2, Ord a1) => (b -> a1) -> (b -> a2) -> b -> b -> Ordering
comparing2 ord0 ord1 x y = foldOrdering [comparing ord0 x y, comparing ord1 x y]

comparing3 :: (Ord a3, Ord a2, Ord a1) => (b -> a1) -> (b -> a2) -> (b -> a3) -> b -> b -> Ordering
comparing3 ord0 ord1 ord2 x y = foldOrdering [comparing ord0 x y, comparing ord1 x y, comparing ord2 x y]
  
foldOrdering :: [Ordering] -> Ordering
foldOrdering = foldl1 compOrdering
  where
    compOrdering EQ x = x
    compOrdering x _ = x
