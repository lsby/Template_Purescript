module Model.Counter where

import Prelude

import Data.Newtype (class Newtype)
import HasJSRep (class HasJSRep)
import OhYes (class HasTSRep)

newtype Counter = Counter Int

derive instance Newtype Counter _

add :: Int -> Counter -> Counter
add s (Counter n) = Counter $ n + s

instance HasJSRep Counter
instance HasTSRep Counter where
  toTSRep _ = "number"
