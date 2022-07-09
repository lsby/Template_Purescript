module Web where

import Prelude

import Data.Argonaut as A
import Data.Either (Either(..))
import Hby.Electron.IPCRenderer (on, send, sendSync)
import Hby.Task (Task)
import Hby.Task as T
import Lib.Vue (VueReactive, mapTaskVueData, mkVueData)
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
state = mkVueData
  { n: emptyCounter
  , hello: "hello, world!"
  , inputTodo: emptyToDoItem
  , toDoList: emptyToDoList
  }

----------------------
-- | 前端事件
type Event =
  { onIncrease :: Task Unit
  , onMakeZero :: Task Unit
  , onSyncSendTest :: Task Unit
  , onAsyncListener :: Task Unit
  , onAsyncSendTest :: Task Unit
  , onUpdateTodoText :: ToDoItem -> Task Unit
  , onAddTodo :: Task Unit
  }

event :: Task (VueReactive Event)
event = do
  s <- state
  mkVueData
    { onIncrease: mapTaskVueData onIncrease s
    , onMakeZero: mapTaskVueData onMakeZero s
    , onSyncSendTest: onSyncSendTest
    , onAsyncListener: onAsyncListener
    , onAsyncSendTest: onAsyncSendTest
    , onUpdateTodoText: \a -> mapTaskVueData (onUpdateTodoText a) s
    , onAddTodo: mapTaskVueData onAddTodo s
    }

----------------------
-- | 当点击添加待办项
onAddTodo :: State -> Task State
onAddTodo s = pure $ s { toDoList = addToDoItem s.inputTodo s.toDoList, inputTodo = emptyToDoItem }

-- | 当输入待办项
onUpdateTodoText :: ToDoItem -> State -> Task State
onUpdateTodoText str s = pure $ s { inputTodo = str }

-- | 当点击增加按钮
onIncrease :: State -> Task State
onIncrease s = pure $ s { n = addCounter 1 s.n }

-- | 当点击归零按钮
onMakeZero :: State -> Task State
onMakeZero s = pure $ s { n = emptyCounter }

-- | 当点击同步测试按钮
onSyncSendTest :: Task Unit
onSyncSendTest = do
  r <- sendSync "testSync" $ A.encodeJson { msg: "testSync-toService" }
  case A.decodeJson r of
    Left err -> do
      T.log $ show err
    Right (rx :: { msg :: String }) -> do
      T.log $ show rx

-- | 当点击异步监听按钮
onAsyncListener :: Task Unit
onAsyncListener = on "testAsync-reply"
  ( \_ a -> do
      case A.decodeJson a of
        Left err -> do
          T.log $ show err
        Right (rx :: { msg :: String }) -> do
          T.log $ show rx
  )

-- | 当点击异步测试按钮
onAsyncSendTest :: Task Unit
onAsyncSendTest = send "testAsync" $ A.encodeJson { msg: "testAsync-toService" }
