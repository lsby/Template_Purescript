module Model.Counter
  ( Counter
  , addCounter
  , emptyCounter
  , getCounterNum
  ) where

import Prelude

import HasJSRep (class HasJSRep)
import Lib.Lib (warnPursType)
import OhYes (class HasTSRep)

-- | 计数器
newtype Counter = Counter Int

-- | 实现ts类型
instance HasJSRep Counter
instance HasTSRep Counter where
  toTSRep _ = warnPursType "Model.Counter.Counter"

-- | 空计数器
emptyCounter :: Counter
emptyCounter = Counter 0

-- | 增加计数器
addCounter :: Int -> Counter -> Counter
addCounter s (Counter n) = Counter $ n + s

-- | 获得计数器数字
getCounterNum :: Counter -> Int
getCounterNum (Counter n) = n
