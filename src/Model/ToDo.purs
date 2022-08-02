module Model.ToDoList where

import Prelude

import Data.Array (cons)
import Lib.LinkTS (class LinkTS, toTSType, toTSValue)
import Type.Proxy (Proxy(..))

-- | todo项
newtype ToDoItem = ToDoItem String

instance LinkTS ToDoItem where
  toTSValue (ToDoItem a) = toTSValue a
  toTSType _ = "string"

-- | todo列表
newtype ToDoList = ToDoList (Array ToDoItem)

instance LinkTS ToDoList where
  toTSValue (ToDoList a) = toTSValue a
  toTSType _ = toTSType (Proxy :: Proxy (Array ToDoItem))

-- | 创建todo项
mkToDoItem :: String -> ToDoItem
mkToDoItem = ToDoItem

-- | 空待办列表
emptyToDoList :: ToDoList
emptyToDoList = ToDoList []

-- | 增加待办事项
addToDoItem :: ToDoItem -> ToDoList -> ToDoList
addToDoItem item (ToDoList arr) = ToDoList $ cons item arr

-- 待办项转字符串
toDoItemToString :: ToDoItem -> String
toDoItemToString (ToDoItem item) = item

-- | 待办列表转数组
toDoListToArray :: ToDoList -> Array String
toDoListToArray (ToDoList list) = map toDoItemToString list
