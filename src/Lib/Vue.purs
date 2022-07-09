module Lib.Vue where

import Prelude

import Data.Symbol (class IsSymbol)
import Hby.Task (Task)
import Prim.Row (class Cons)
import Type.Proxy (Proxy)

-- | vue响应式对象
newtype VueReactive a = VueReactive a

-- | 创建一个vue响应式对象
foreign import mkVueData
  :: forall obj
   . Record obj
  -> Task (VueReactive (Record obj))

-- | 获得一个vue响应式对象的值
-- | 获得的是原始值而不是响应式值
foreign import getVueData
  :: forall key value tail obj
   . IsSymbol key
  => Cons key value tail obj
  => Proxy key
  -> VueReactive (Record obj)
  -> Task value

-- | 设置一个vue响应式对象的值
foreign import setVueData
  :: forall key value tail obj
   . IsSymbol key
  => Cons key value tail obj
  => Proxy key
  -> value
  -> VueReactive (Record obj)
  -> Task Unit

-- | 修改一个vue响应式对象的值
foreign import overVueData
  :: forall key value tail obj
   . IsSymbol key
  => Cons key value tail obj
  => Proxy key
  -> (value -> value)
  -> VueReactive (Record obj)
  -> Task Unit

-- | 以副作用方式更新响应式对象
-- | 函数获得的值是原始值而不是响应式值
foreign import mapTaskVueData
  :: forall obj
   . (Record obj -> Task (Record obj))
  -> VueReactive (Record obj)
  -> Task Unit
