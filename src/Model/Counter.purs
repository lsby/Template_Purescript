module Model.Counter where

import Prelude

import Data.Generic.Rep (class Generic)

-- | 计数器
newtype Counter = Counter Int

derive instance Generic Counter _

-- | 空计数器
emptyCounter :: Counter
emptyCounter = Counter 0

-- | 增加计数器
addCounter :: Int -> Counter -> Counter
addCounter s (Counter n) = Counter $ n + s

-- | 获得计数器数字
getCounterNum :: Counter -> Int
getCounterNum (Counter n) = n
