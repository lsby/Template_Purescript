module Lib.Vue where

import Prelude

import Data.Symbol (class IsSymbol)
import Hby.Task (Task)
import Prim.Row (class Cons)
import Type.Proxy (Proxy)

-- | vue响应式对象
newtype VueReactive a = VueReactive a

-- | 创建一个vue响应式对象
foreign import mk
  :: forall obj
   . Record obj
  -> Task (VueReactive (Record obj))

-- | 获得一个vue响应式对象的值
-- | 获得的是原始值而不是响应式值
foreign import get
  :: forall key value tail obj
   . IsSymbol key
  => Cons key value tail obj
  => Proxy key
  -> VueReactive (Record obj)
  -> Task value

-- | 设置一个vue响应式对象的值
foreign import set
  :: forall key value tail obj
   . IsSymbol key
  => Cons key value tail obj
  => Proxy key
  -> value
  -> VueReactive (Record obj)
  -> Task Unit

-- | 修改一个vue响应式对象的值
foreign import over
  :: forall key value tail obj
   . IsSymbol key
  => Cons key value tail obj
  => Proxy key
  -> (value -> value)
  -> VueReactive (Record obj)
  -> Task Unit

-- | 映射一个vue响应式对象
-- | 映射函数获得的值是原始值而不是响应式值
foreign import apply
  :: forall obj
   . (Record obj -> Task (Record obj))
  -> VueReactive (Record obj)
  -> Task Unit
