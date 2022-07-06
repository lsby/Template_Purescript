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
  { onClick_Increase :: Task Unit
  , onClick_MakeZero :: Task Unit
  , onClick_SyncSendTest :: Task Unit
  , onClick_AsyncListener :: Task Unit
  , onClick_AsyncSendTest :: Task Unit
  , onInput_Todo :: String -> Task Unit
  , onClick_AddTodo :: Task Unit
  }

event :: Task (VueReactive Event)
event = do
  s <- state
  V.mk
    { onClick_Increase: V.apply onClick_Increase s
    , onClick_MakeZero: V.apply onClick_MakeZero s
    , onClick_SyncSendTest: LibW.onClick_SyncSendTest
    , onClick_AsyncListener: LibW.onClick_AsyncListener
    , onClick_AsyncSendTest: LibW.onClick_AsyncSendTest
    , onInput_Todo: \str -> V.apply (onInput_Todo str) s
    , onClick_AddTodo: V.apply onClick_AddTodo s
    }

----------------------
-- | 当点击添加待办项
onClick_AddTodo :: State -> Task State
onClick_AddTodo s = pure $ s { toDoList = Array.cons s.inputTodo s.toDoList, inputTodo = "" }

-- | 当输入待办项
onInput_Todo :: String -> State -> Task State
onInput_Todo str s = pure $ s { inputTodo = str }

-- | 当点击增加按钮
onClick_Increase :: State -> Task State
onClick_Increase s = pure $ s { n = Counter.add 1 s.n }

-- | 当点击归零按钮
onClick_MakeZero :: State -> Task State
onClick_MakeZero s = pure $ s { n = Counter 0 }
