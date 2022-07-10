module Model.Counter
  ( Counter
  , addCounter
  , emptyCounter
  ) where

----------------------

import Prelude

import HasJSRep (class HasJSRep)
import Lib.Lib (genPureType)
import OhYes (class HasTSRep)

----------------------
-- | 计数器
newtype Counter = Counter Int

instance HasJSRep Counter
instance HasTSRep Counter where
  toTSRep _ = genPureType "Counter"

----------------------
-- | 空计数器
emptyCounter :: Counter
emptyCounter = Counter 0

-- | 增加计数器
addCounter :: Int -> Counter -> Counter
addCounter s (Counter n) = Counter $ n + s
