module Web (state, event) where

import Prelude

import Hby.Task (Task)
import Lib.Vue (VueReactive)
import Lib.Vue as V
import Type.Proxy (Proxy(..))

----------------------
type State =
  { n :: Int
  , hello :: String
  }

state :: Task (VueReactive State)
state = V.mk
  { n: 0
  , hello: "hello, world!"
  }

----------------------
add1 :: Int -> Int
add1 a = a + 1

increase :: VueReactive State -> Task Unit
increase ref = do
  V.over (Proxy :: Proxy "n") (add1) ref

makeZero :: VueReactive State -> Task Unit
makeZero ref = do
  V.set (Proxy :: Proxy "n") 0 ref

----------------------
type Event =
  { increase :: Task Unit
  , makeZero :: Task Unit
  }

event :: Task (VueReactive Event)
event = do
  s <- state
  V.mk
    { increase: increase s
    , makeZero: makeZero s
    }
