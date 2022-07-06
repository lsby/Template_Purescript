module Lib.DB where

import Data.Maybe (Maybe(..))
import Hby.Task (Task)

----------------------
foreign import _getNameById :: (forall a. a -> Maybe a) -> (forall a. Maybe a) -> Int -> Task (Maybe String)

-- | 通过学生id获得学生姓名
getNameById :: Int -> Task (Maybe String)
getNameById id = _getNameById Just Nothing id

----------------------
