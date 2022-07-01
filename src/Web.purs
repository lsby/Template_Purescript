module Web where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Hby.Task (Task)
import Lib.Vue (VueReactive)
import Lib.Vue as V
import Type.Proxy (Proxy(..))

----------------------
newtype State = State
  ( VueReactive
      { a :: Int
      , b :: String
      , hello :: Effect Unit
      , myAdd :: Int -> Int -> Int
      , increase :: State -> Task Unit
      }
  )

----------------------
hello :: Effect Unit
hello = log "hello, world."

myAdd :: Int -> Int -> Int
myAdd a b = a + b

increase :: State -> Task Unit
increase (State st) = V.set (Proxy :: Proxy "a") 3 st

----------------------
state :: State
state = State $ V.mk
  { a: 1
  , b: "abc"
  , hello
  , myAdd
  , increase
  }
