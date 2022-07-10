module Model.ToDoList
  ( ToDoList
  , ToDoItem
  , emptyToDoList
  , emptyToDoItem
  , addToDoItem
  ) where

----------------------

import Prelude

import Data.Array (cons)
import HasJSRep (class HasJSRep)
import Lib.Lib (genPureArrayType, genPureType)
import OhYes (class HasTSRep)

----------------------
-- | todo项
newtype ToDoItem = ToDoItem String

instance HasJSRep ToDoItem
instance HasTSRep ToDoItem where
  toTSRep _ = genPureType "ToDoItem"

----------------------
-- | todo列表
newtype ToDoList = ToDoList (Array ToDoItem)

instance HasJSRep ToDoList
instance HasTSRep ToDoList where
  toTSRep _ = genPureArrayType "ToDoItem"

----------------------
-- | 空待办列表
emptyToDoList :: ToDoList
emptyToDoList = ToDoList []

-- | 空待办项
emptyToDoItem :: ToDoItem
emptyToDoItem = ToDoItem ""

-- | 增加待办事项
addToDoItem :: ToDoItem -> ToDoList -> ToDoList
addToDoItem item (ToDoList arr) = ToDoList $ cons item arr
