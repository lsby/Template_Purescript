module Lib.Lib where

import Prelude

import Hby.Task (Task)
import Hby.Task as T

----------------------
foreign import testFun :: Task Unit

----------------------
hello :: Task Unit
hello = T.log "hello, world!"
