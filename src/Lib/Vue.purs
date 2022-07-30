module Lib.Vue where

import Prelude

import Hby.Task (Task)

-- | vue响应式对象
newtype VueReactive a = VueReactive a

-- | 把数据包装成vue对象
foreign import wrapVueData :: forall a. a -> Task (VueReactive (a))

-- | 不安全的把数据包装成vue对象
foreign import unsafeWrapVueData :: forall a. a -> VueReactive (a)

-- | 把vue对象解包
foreign import unwrapVueData :: forall a. VueReactive a -> Task a

-- | 设置vue对象的所有值
foreign import setVueDateValue :: forall a. a -> VueReactive a -> Task Unit
