module Model.Counter where

import Prelude
import Data.Newtype (class Newtype)

newtype Counter = Counter Int

derive instance Newtype Counter _

add :: Int -> Counter -> Counter
add s (Counter n) = Counter $ n + s
