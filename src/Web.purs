module Web where

import Prelude

import Data.Argonaut as A
import Data.Either (Either(..))
import Effect.Class (liftEffect)
import Effect.Ref (Ref)
import Effect.Ref as Ref
import Hby.Electron.IPCRenderer (on, send, sendSync)
import Hby.Task (Task)
import Hby.Task as T
import Lib.Vue (VueReactive, mkVueData, setAllVueData)
import Model.Counter (Counter, addCounter, emptyCounter, getCounterNum)
import Model.ToDoList (ToDoList, addToDoItem, emptyToDoList, mkToDoItem, toDoListToArray)

----------------------
-- | 包装事件函数
wrapEvent :: (ProcState -> Task ProcState) -> VueReactive State -> Ref ProcState -> Task Unit
wrapEvent f s ref = do
  p <- liftEffect $ Ref.read ref
  p' <- f p
  liftEffect $ Ref.write p' ref
  setAllVueData (procStateToState p') s

-- | 入口
main :: Task { event :: Event, state :: VueReactive State }
main = do
  ref <- liftEffect $ Ref.new procState
  ps <- liftEffect $ Ref.read ref
  s <- mkVueData (procStateToState ps)
  e <- pure (event s ref)
  pure { state: s, event: e }

----------------------
-- | 程序状态类型
type ProcState =
  { counter :: Counter
  , hello :: String
  , inputTodo :: String
  , toDoList :: ToDoList
  }

-- | 程序状态
procState :: ProcState
procState =
  { hello: "hello, world!"
  , counter: emptyCounter
  , inputTodo: ""
  , toDoList: emptyToDoList
  }

----------------------
-- | 前端状态类型
type State =
  { hello :: String
  , n :: Int
  , inputTodo :: String
  , toDoList :: Array String
  }

-- | 程序状态转前端状态
procStateToState :: ProcState -> State
procStateToState p = do
  { hello: p.hello
  , n: getCounterNum p.counter
  , inputTodo: p.inputTodo
  , toDoList: toDoListToArray p.toDoList
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
event :: VueReactive State -> Ref ProcState -> Event
event s p =
  { onSyncSendTest: onSyncSendTest
  , onAsyncListener: onAsyncListener
  , onAsyncSendTest: onAsyncSendTest
  , onIncrease: wrapEvent onIncrease s p
  , onMakeZero: wrapEvent onMakeZero s p
  , onUpdateTodoText: \a -> wrapEvent (onUpdateTodoText a) s p
  , onAddTodo: wrapEvent onAddTodo s p
  }

----------------------
-- | 当点击添加待办项
onAddTodo :: ProcState -> Task ProcState
onAddTodo s
  | s.inputTodo == "" = pure $ s
  | otherwise = pure $ s
      { toDoList = addToDoItem (mkToDoItem s.inputTodo) s.toDoList
      , inputTodo = ""
      }

-- | 当输入待办项
onUpdateTodoText :: String -> ProcState -> Task ProcState
onUpdateTodoText str s = pure $ s { inputTodo = str }

-- | 当点击增加按钮
onIncrease :: ProcState -> Task ProcState
onIncrease s = pure $ s { counter = addCounter 1 s.counter }

-- | 当点击归零按钮
onMakeZero :: ProcState -> Task ProcState
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
