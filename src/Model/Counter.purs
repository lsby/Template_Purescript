module Model.Counter
  ( Counter
  , addCounter
  , emptyCounter
  , getCounterNum
  ) where

import Prelude

-- | 计数器
newtype Counter = Counter Int

-- | 空计数器
emptyCounter :: Counter
emptyCounter = Counter 0

-- | 增加计数器
addCounter :: Int -> Counter -> Counter
addCounter s (Counter n) = Counter $ n + s

-- | 获得计数器数字
getCounterNum :: Counter -> Int
getCounterNum (Counter n) = n
