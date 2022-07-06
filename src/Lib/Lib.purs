-- 注意: 前后端的Lib应该分开, 一些后端API在打包为在前端会报错.
----------------------
module Lib.Lib where

import Prelude

import Hby.Task (Task)
import Hby.Task as T

----------------------
-- | 测试函数
foreign import testFun :: Task Unit

-- | 初始化环境变量
foreign import initEnv :: Task Unit

----------------------
-- | 测试函数
hello :: Task Unit
hello = T.log "hello, world!"
