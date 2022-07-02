module Model.Counter where

import Data.Newtype (class Newtype)

newtype Counter = Counter Int

derive instance Newtype Counter _
