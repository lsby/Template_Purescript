module Lib.LinkTS where

import Prelude

import Data.Generic.Rep (class Generic, Argument(..), Constructor(..), NoArguments, Product(..), Sum(..), from)
import Data.Symbol (class IsSymbol)
import Foreign (Foreign, unsafeToForeign)
import Prim.Row (class Cons, class Lacks)
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL
import Record (delete, get)
import Type.Proxy (Proxy(..))
import Hby.Task (Task)
import Type.Prelude (reflectSymbol)

---------------------------------------------
class GetRecordTsValue :: Row Type -> RowList Type -> Constraint
class GetRecordTsValue row rowList | rowList -> row where
  getRecordTsValue :: (RowToList row rowList) => Record row -> Foreign

instance GetRecordTsValue () (RL.Nil) where
  getRecordTsValue _ = unsafeToForeign unit

instance
  ( Cons k v tr row
  , IsSymbol k
  , GenTypeToTsValue v v'
  , RowToList tr trList
  , GetRecordTsValue tr trList
  , Lacks k tr
  ) =>
  GetRecordTsValue row (RL.Cons k v tl) where
  getRecordTsValue r = unsafeToForeign $
    { key: reflectSymbol (Proxy :: Proxy k)
    , value: genToTsValue (get (Proxy :: Proxy k) r)
    , tail: getRecordTsValue (delete (Proxy :: Proxy k) r)
    }

foreign import trForeignRecordTsValue :: Foreign -> Foreign
foreign import trForeignSumTsValue :: Array Foreign -> Array Foreign

class GenTypeToTsValue :: Type -> Type -> Constraint
class GenTypeToTsValue a b | a -> b where
  genToTsValue :: a -> b

instance GenTypeToTsValue (Int) (Int) where
  genToTsValue a = a
else instance GenTypeToTsValue (Number) (Number) where
  genToTsValue a = a
else instance GenTypeToTsValue (String) (String) where
  genToTsValue a = a
else instance GenTypeToTsValue (Boolean) (Boolean) where
  genToTsValue a = a
else instance (GenTypeToTsValue a a') => GenTypeToTsValue (Array a) (Array a') where
  genToTsValue a = map genToTsValue a
else instance (GetRecordTsValue row rowList, RowToList row rowList) => GenTypeToTsValue (Record row) (Foreign) where
  genToTsValue a = trForeignRecordTsValue $ getRecordTsValue a
else instance (GenTypeToTsValue a b) => GenTypeToTsValue (Argument a) (b) where
  genToTsValue (Argument a) = genToTsValue a
else instance (IsSymbol name) => GenTypeToTsValue (Constructor name NoArguments) String where
  genToTsValue _ = reflectSymbol (Proxy :: Proxy name)
else instance (GenTypeToTsValue a a', GenTypeToTsValue b b', IsSymbol name) => GenTypeToTsValue (Constructor name (Product a b)) (Array Foreign) where
  genToTsValue (Constructor a) = trForeignSumTsValue $ genToTsValue a
else instance (GenTypeToTsValue a b, IsSymbol name) => GenTypeToTsValue (Constructor name a) (b) where
  genToTsValue (Constructor a) = genToTsValue a
else instance (GenTypeToTsValue a a', GenTypeToTsValue b b') => GenTypeToTsValue (Sum a b) (Foreign) where
  genToTsValue (Inl a) = unsafeToForeign (genToTsValue a)
  genToTsValue (Inr b) = unsafeToForeign (genToTsValue b)
else instance (GenTypeToTsValue a a', GenTypeToTsValue b b') => GenTypeToTsValue (Product a b) (Array Foreign) where
  genToTsValue (Product a b) = [ unsafeToForeign (genToTsValue a), unsafeToForeign (genToTsValue b) ]
else instance (Generic a t, GenTypeToTsValue t t') => GenTypeToTsValue (a) (t') where
  genToTsValue a = genToTsValue (from a)

-- | 将给定的值转换为js的值
-- |
-- | - 基础类型会直接对应转换
-- | - 数组和对象会直接对应转换
-- | - 单构造子包装会把包装去掉
-- | - 和类型会把包装去掉
-- | - 积类型会转换为元组
-- |
-- | 需要实现 Generic 类型类
valueToTsValue :: forall t a b. GenTypeToTsValue t b => Generic a t => a -> b
valueToTsValue x = genToTsValue $ from x

---------------------------------------------
class GetRecordTsType :: RowList Type -> Constraint
class GetRecordTsType a where
  getRecordTsType :: Proxy a -> Foreign

instance GetRecordTsType (RL.Nil) where
  getRecordTsType _ = unsafeToForeign unit

instance (GetRecordTsType tl, GenTypeProxyToTsType v, IsSymbol k) => GetRecordTsType (RL.Cons k v tl) where
  getRecordTsType _ = unsafeToForeign $
    { key: unsafeToForeign $ reflectSymbol (Proxy :: Proxy k)
    , value: unsafeToForeign $ genTypeProxyToTsType (Proxy :: Proxy v)
    , tail: unsafeToForeign $ getRecordTsType (Proxy :: Proxy tl)
    }

foreign import trForeignRecordTsType :: Foreign -> String

getValueTypeProxy :: forall a. a -> Proxy a
getValueTypeProxy _ = Proxy

class GenTypeProxyToTsType :: Type -> Constraint
class GenTypeProxyToTsType a where
  genTypeProxyToTsType :: (Proxy a) -> String

instance GenTypeProxyToTsType Int where
  genTypeProxyToTsType _ = "number"
else instance GenTypeProxyToTsType Number where
  genTypeProxyToTsType _ = "number"
else instance GenTypeProxyToTsType String where
  genTypeProxyToTsType _ = "string"
else instance GenTypeProxyToTsType Boolean where
  genTypeProxyToTsType _ = "boolean"
else instance GenTypeProxyToTsType Unit where
  genTypeProxyToTsType _ = "void"
else instance (GenTypeProxyToTsType a) => GenTypeProxyToTsType (Task a) where
  genTypeProxyToTsType _ = "() => Promise<" <> genTypeProxyToTsType (Proxy :: Proxy a) <> ">"
else instance (GenTypeProxyToTsType a, GenTypeProxyToTsType b) => GenTypeProxyToTsType (a -> b) where
  genTypeProxyToTsType _ = "(a:" <> genTypeProxyToTsType (Proxy :: Proxy a) <> ") => " <> genTypeProxyToTsType (Proxy :: Proxy b)
else instance (RowToList row rowList, GetRecordTsType rowList) => GenTypeProxyToTsType (Record row) where
  genTypeProxyToTsType _ = trForeignRecordTsType $ getRecordTsType (Proxy :: Proxy rowList)
else instance (GenTypeProxyToTsType a) => GenTypeProxyToTsType (Array a) where
  genTypeProxyToTsType _ = "Array<" <> genTypeProxyToTsType (Proxy :: Proxy a) <> ">"
else instance (GenTypeProxyToTsType a, GenTypeProxyToTsType b) => GenTypeProxyToTsType (Sum a b) where
  genTypeProxyToTsType _ = genTypeProxyToTsType (Proxy :: Proxy a) <> " | " <> genTypeProxyToTsType (Proxy :: Proxy b)
else instance (GenTypeProxyToTsType a, GenTypeProxyToTsType b) => GenTypeProxyToTsType (Constructor name (Product a b)) where
  genTypeProxyToTsType _ = "[" <> genTypeProxyToTsType (Proxy :: Proxy (Product a b)) <> "]"
else instance (GenTypeProxyToTsType a, GenTypeProxyToTsType b) => GenTypeProxyToTsType (Product a b) where
  genTypeProxyToTsType _ = genTypeProxyToTsType (Proxy :: Proxy a) <> ", " <> genTypeProxyToTsType (Proxy :: Proxy b)
else instance (GenTypeProxyToTsType t) => GenTypeProxyToTsType (Argument t) where
  genTypeProxyToTsType _ = genTypeProxyToTsType (Proxy :: Proxy t)
else instance (IsSymbol name) => GenTypeProxyToTsType (Constructor name NoArguments) where
  genTypeProxyToTsType _ = "\"" <> reflectSymbol (Proxy :: Proxy name) <> "\""
else instance (GenTypeProxyToTsType t) => GenTypeProxyToTsType (Constructor name t) where
  genTypeProxyToTsType _ = genTypeProxyToTsType (Proxy :: Proxy t)
else instance (Generic a t, GenTypeProxyToTsType t) => GenTypeProxyToTsType (a) where
  genTypeProxyToTsType _ = genTypeProxyToTsType (Proxy :: Proxy t)

-- | 将给定的值转换为ts的类型
-- |
-- | - 基础类型会直接对应转换
-- | - 数组和对象会直接对应转换
-- | - 单构造子包装会把包装去掉
-- | - 和类型会转换为ts的和类型
-- | - 积类型会转换为ts的元组类型
-- |
-- | 需要实现 Generic 类型类
valueTypeToTsType :: forall a b. GenTypeProxyToTsType a => Generic b a => String -> b -> String
valueTypeToTsType name a = "export type " <> name <> " = " <> genTypeProxyToTsType (getValueTypeProxy (from a))

