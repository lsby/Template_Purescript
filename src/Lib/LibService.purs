module Lib.LibService where

import Prelude

import Hby.Task (Task)
import Hby.Task as T

----------------------
-- | 初始化环境变量
foreign import initEnv :: Task Unit

----------------------
-- | 测试函数
hello :: Task Unit
hello = T.log "hello, world!"
