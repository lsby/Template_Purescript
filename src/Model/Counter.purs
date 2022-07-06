module Model.Counter where

import Prelude

import Data.Newtype (class Newtype)
import HasJSRep (class HasJSRep)
import OhYes (class HasTSRep)

----------------------
-- | 计数器
newtype Counter = Counter Int

derive instance Newtype Counter _

instance HasJSRep Counter
instance HasTSRep Counter where
  toTSRep _ = "number"

----------------------
-- | 增加计数器
add :: Int -> Counter -> Counter
add s (Counter n) = Counter $ n + s
