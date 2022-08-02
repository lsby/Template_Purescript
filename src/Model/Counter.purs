module Model.Counter where

import Prelude

import Lib.LinkTS (class LinkTS, toTSValue)

-- | 计数器
newtype Counter = Counter Int

instance LinkTS Counter where
  toTSValue (Counter a) = toTSValue a
  toTSType _ = "number"

-- | 空计数器
emptyCounter :: Counter
emptyCounter = Counter 0

-- | 增加计数器
addCounter :: Int -> Counter -> Counter
addCounter s (Counter n) = Counter $ n + s

-- | 获得计数器数字
getCounterNum :: Counter -> Int
getCounterNum (Counter n) = n
