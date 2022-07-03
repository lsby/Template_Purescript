module Lib.LibService where

import Prelude
import Hby.Task (Task)
import Hby.Task as T

----------------------
foreign import initEnv :: Task Unit

----------------------
hello :: Task Unit
hello = T.log "hello, world!"
