module Lib.DB where

import Data.Maybe (Maybe(..))
import Hby.Task (Task)

----------------------
-- | 学生id
newtype StudentId = StudentId Int

-- | 学生姓名
newtype StudentName = StudentName String

----------------------
foreign import _getNameById :: (forall a. a -> Maybe a) -> (forall a. Maybe a) -> StudentId -> Task (Maybe StudentName)

-- | 通过学生id获得学生姓名
getNameById :: StudentId -> Task (Maybe StudentName)
getNameById id = _getNameById Just Nothing id

----------------------
