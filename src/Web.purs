module Web where

import Prelude

import Data.Argonaut as A
import Data.Either (Either(..))
import Hby.Electron.IPCRenderer (on, send, sendSync)
import Hby.Task (Task)
import Hby.Task as T
import Lib.Vue (VueReactive, mapTaskVueData, mkVueData)
import Model.Counter (Counter, addCounter, emptyCounter, getCounterNum)
import Model.ToDoList (ToDoList, addToDoItem, emptyToDoList, mkToDoItem)

----------------------
-- | 前端状态类型
type State =
  { counter :: Counter
  , hello :: String
  , inputTodo :: String
  , toDoList :: ToDoList
  }

state :: Task (VueReactive State)
state = mkVueData
  { hello: "hello, world!"
  , counter: emptyCounter
  , inputTodo: ""
  , toDoList: emptyToDoList
  }

----------------------
-- | 前端事件类型
type Event =
  { onSyncSendTest :: Task Unit
  , onAsyncListener :: Task Unit
  , onAsyncSendTest :: Task Unit
  , onIncrease :: Task Unit
  , onMakeZero :: Task Unit
  , onUpdateTodoText :: String -> Task Unit
  , onAddTodo :: Task Unit
  , getCounterNum :: Counter -> Int
  }

-- | 前端事件
event :: Task Event
event = do
  s <- state
  pure
    { onSyncSendTest: onSyncSendTest
    , onAsyncListener: onAsyncListener
    , onAsyncSendTest: onAsyncSendTest
    , onIncrease: mapTaskVueData onIncrease s
    , onMakeZero: mapTaskVueData onMakeZero s
    , onUpdateTodoText: \a -> mapTaskVueData (onUpdateTodoText a) s
    , onAddTodo: mapTaskVueData onAddTodo s
    , getCounterNum: getCounterNum
    }

----------------------
-- | 当点击添加待办项
onAddTodo :: State -> Task State
onAddTodo s
  | s.inputTodo == "" = pure $ s
  | otherwise = pure $ s
      { toDoList = addToDoItem (mkToDoItem s.inputTodo) s.toDoList
      , inputTodo = ""
      }

-- | 当输入待办项
onUpdateTodoText :: String -> State -> Task State
onUpdateTodoText str s = pure $ s { inputTodo = str }

-- | 当点击增加按钮
onIncrease :: State -> Task State
onIncrease s = pure $ s { counter = addCounter 1 s.counter }

-- | 当点击归零按钮
onMakeZero :: State -> Task State
onMakeZero s = pure $ s { counter = emptyCounter }

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
