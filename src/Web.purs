module Web where

import Prelude

import Data.Argonaut as A
import Data.Either (Either(..))
import Foreign (Foreign, unsafeToForeign)
import Hby.Electron.IPCRenderer (on, send, sendSync)
import Hby.Task (Task)
import Hby.Task as T
import Lib.LinkTS (toTSValue)
import Lib.Vue (VueReactive, setVueDateValue, unsafeWrapVueData, unwrapVueData)
import Model.Counter (Counter, addCounter, emptyCounter)
import Model.ToDoList (ToDoList, addToDoItem, emptyToDoList, mkToDoItem)
import Unsafe.Coerce (unsafeCoerce)

----------------------
-- | 入口
main :: Task ({ state :: Foreign, event :: Foreign })
main = pure
  { state: unsafeToForeign $ vueData
  , event: unsafeToForeign $ event
  }

-- | 全局vue状态
vueData :: VueReactive State
vueData = unsafeCoerce unsafeWrapVueData (toTSValue state)

-- | 包装转换函数
wrapVueEvent :: (State -> Task State) -> Task Unit
wrapVueEvent f = do
  vd <- unwrapVueData vueData
  r <- f vd
  setVueDateValue r vueData

----------------------
-- | 前端状态类型
type State =
  { counter :: Counter
  , hello :: String
  , inputTodo :: String
  , toDoList :: ToDoList
  }

-- | 前端状态值
state :: State
state =
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
  }

-- | 前端事件
event :: Event
event =
  { onSyncSendTest: onSyncSendTest
  , onAsyncListener: onAsyncListener
  , onAsyncSendTest: onAsyncSendTest
  , onIncrease: wrapVueEvent onIncrease
  , onMakeZero: wrapVueEvent onMakeZero
  , onUpdateTodoText: \a -> wrapVueEvent (onUpdateTodoText a)
  , onAddTodo: wrapVueEvent onAddTodo
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
onUpdateTodoText str s = pure $ (s { inputTodo = str })

-- | 当点击增加按钮
onIncrease :: State -> Task State
onIncrease s = pure $ (s { counter = addCounter 1 s.counter })

-- | 当点击归零按钮
onMakeZero :: State -> Task State
onMakeZero s = pure $ (s { counter = emptyCounter })

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
