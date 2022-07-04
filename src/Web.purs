module Web where

import Prelude

import Data.Array as Array
import Hby.Task (Task)
import Lib.LibWeb as LibW
import Lib.Vue (VueReactive)
import Lib.Vue as V
import Model.Counter (Counter(..))
import Model.Counter as Counter

----------------------
type State =
  { n :: Counter
  , hello :: String
  , inputTodo :: String
  , toDoList :: Array String
  }

state :: Task (VueReactive State)
state = V.mk
  { n: Counter 0
  , hello: "hello, world!"
  , inputTodo: ""
  , toDoList: []
  }

----------------------
type Event =
  { increase :: Task Unit
  , makeZero :: Task Unit
  , testElectronSync :: Task Unit
  , testElectronAsync_on :: Task Unit
  , testElectronAsync_send :: Task Unit
  , inputTodo :: String -> Task Unit
  , addTodo :: Task Unit
  }

event :: Task (VueReactive Event)
event = do
  s <- state
  V.mk
    { increase: V.apply increase s
    , makeZero: V.apply makeZero s
    , testElectronSync: LibW.testElectronSync
    , testElectronAsync_on: LibW.testElectronAsync_on
    , testElectronAsync_send: LibW.testElectronAsync_send
    , inputTodo: \str -> V.apply (inputTodo str) s
    , addTodo: V.apply addTodo s
    }

----------------------
addTodo :: State -> Task State
addTodo s = pure $ s { toDoList = Array.cons s.inputTodo s.toDoList, inputTodo = "" }

inputTodo :: String -> State -> Task State
inputTodo str s = pure $ s { inputTodo = str }

increase :: State -> Task State
increase s = pure $ s { n = Counter.add 1 s.n }

makeZero :: State -> Task State
makeZero s = pure $ s { n = Counter 0 }
