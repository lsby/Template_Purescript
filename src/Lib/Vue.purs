module Lib.Vue where

import Prelude
import Data.Symbol (class IsSymbol)
import Hby.Task (Task)
import Prim.Row (class Cons)
import Type.Proxy (Proxy)

newtype VueReactive a = VueReactive a

foreign import mk
  :: forall obj
   . Record obj
  -> Task (VueReactive (Record obj))

foreign import toRaw
  :: forall obj
   . VueReactive (Record obj)
  -> Task (Record obj)

foreign import get
  :: forall key value tail obj
   . IsSymbol key
  => Cons key value tail obj
  => Proxy key
  -> VueReactive (Record obj)
  -> Task (VueReactive (Record obj))

foreign import set
  :: forall key value tail obj
   . IsSymbol key
  => Cons key value tail obj
  => Proxy key
  -> value
  -> VueReactive (Record obj)
  -> Task Unit

foreign import over
  :: forall key value tail obj
   . IsSymbol key
  => Cons key value tail obj
  => Proxy key
  -> (value -> value)
  -> VueReactive (Record obj)
  -> Task Unit