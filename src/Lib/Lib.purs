module Lib.Lib where

import Prelude

import Hby.Task (Task)
import Hby.Task as T

----------------------
-- | 测试函数
foreign import testFun :: Task Unit

----------------------
-- | 测试函数
hello :: Task Unit
hello = T.log "hello, world!"
