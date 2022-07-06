module Lib.DB where

import Hby.Task (Task)

-- | 通过id获得学生姓名
foreign import getNameById :: Int -> Task (Array { "姓名" :: String })
