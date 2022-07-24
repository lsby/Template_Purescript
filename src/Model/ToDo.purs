module Model.ToDoList
  ( ToDoList
  , ToDoItem
  , mkToDoItem
  , emptyToDoList
  , addToDoItem
  , toDoItemToString
  , toDoListToArray
  ) where

import Prelude

import Data.Array (cons)
import HasJSRep (class HasJSRep)
import OhYes (class HasTSRep, toTSRep)
import Type.Proxy (Proxy(..))

-- | todo项
newtype ToDoItem = ToDoItem String

-- | 实现转换到ts类型
instance HasJSRep ToDoItem
instance HasTSRep ToDoItem where
  toTSRep _ = "string"

-- | todo列表
newtype ToDoList = ToDoList (Array ToDoItem)

-- | 实现转换到ts类型
instance HasJSRep ToDoList
instance HasTSRep ToDoList where
  toTSRep _ = "Array<" <> toTSRep (Proxy :: Proxy ToDoItem) <> ">"

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
