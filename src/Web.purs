module Web where

import Prelude

import Data.Argonaut as A
import Data.Either (Either(..))
import Hby.Electron.IPCRenderer (on, send, sendSync)
import Hby.Task (Task)
import Hby.Task as T
import Lib.Vue (VueReactive)
import Lib.Vue as V
import Model.Counter (Counter, addCounter, emptyCounter)
import Model.ToDoList (ToDoItem, ToDoList, addToDoItem, emptyToDoItem, emptyToDoList)

----------------------
-- | 前端状态
type State =
  { n :: Counter
  , hello :: String
  , inputTodo :: ToDoItem
  , toDoList :: ToDoList
  }

state :: Task (VueReactive State)
state = V.mk
  { n: emptyCounter
  , hello: "hello, world!"
  , inputTodo: emptyToDoItem
  , toDoList: emptyToDoList
  }

----------------------
-- | 前端事件
type Event =
  { onClick_Increase :: Task Unit
  , onClick_MakeZero :: Task Unit
  , onClick_SyncSendTest :: Task Unit
  , onClick_AsyncListener :: Task Unit
  , onClick_AsyncSendTest :: Task Unit
  , onInput_Todo :: ToDoItem -> Task Unit
  , onClick_AddTodo :: Task Unit
  }

event :: Task (VueReactive Event)
event = do
  s <- state
  V.mk
    { onClick_Increase: V.apply onClick_Increase s
    , onClick_MakeZero: V.apply onClick_MakeZero s
    , onClick_SyncSendTest: onClick_SyncSendTest
    , onClick_AsyncListener: onClick_AsyncListener
    , onClick_AsyncSendTest: onClick_AsyncSendTest
    , onInput_Todo: \a -> V.apply (onInput_Todo a) s
    , onClick_AddTodo: V.apply onClick_AddTodo s
    }

----------------------
-- | 当点击添加待办项
onClick_AddTodo :: State -> Task State
onClick_AddTodo s = pure $ s { toDoList = addToDoItem s.inputTodo s.toDoList, inputTodo = emptyToDoItem }

-- | 当输入待办项
onInput_Todo :: ToDoItem -> State -> Task State
onInput_Todo str s = pure $ s { inputTodo = str }

-- | 当点击增加按钮
onClick_Increase :: State -> Task State
onClick_Increase s = pure $ s { n = addCounter 1 s.n }

-- | 当点击归零按钮
onClick_MakeZero :: State -> Task State
onClick_MakeZero s = pure $ s { n = emptyCounter }

-- | 当点击同步测试按钮
onClick_SyncSendTest :: Task Unit
onClick_SyncSendTest = do
  r <- sendSync "testSync" $ A.encodeJson { msg: "testSync-toService" }
  case A.decodeJson r of
    Left err -> do
      T.log $ show err
    Right (rx :: { msg :: String }) -> do
      T.log $ show rx

-- | 当点击异步监听按钮
onClick_AsyncListener :: Task Unit
onClick_AsyncListener = on "testAsync-reply"
  ( \_ a -> do
      case A.decodeJson a of
        Left err -> do
          T.log $ show err
        Right (rx :: { msg :: String }) -> do
          T.log $ show rx
  )

-- | 当点击异步测试按钮
onClick_AsyncSendTest :: Task Unit
onClick_AsyncSendTest = send "testAsync" $ A.encodeJson { msg: "testAsync-toService" }
