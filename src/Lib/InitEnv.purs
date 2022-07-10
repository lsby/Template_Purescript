module Lib.InitEnv where

import Prelude

import Hby.Task (Task)

-- | 初始化环境变量
foreign import initEnv :: Task Unit