module Lib.Lib where

import Prelude
import Hby.Task (Task)

foreign import initEnv :: Task Unit

foreign import testFun :: Task Unit
