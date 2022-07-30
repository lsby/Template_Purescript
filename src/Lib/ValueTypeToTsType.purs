-- | 将给定的值转换为ts的类型
-- |
-- | - 基础类型会直接对应转换
-- | - 数组和对象会直接对应转换
-- | - 单构造子包装会把包装去掉
-- | - 和类型会转换为ts的和类型
-- | - 积类型会转换为ts的元组类型
-- |
-- | 需要实现 Generic 类型类

module ValueTypeToTsType where

import Prelude

import Data.Generic.Rep (class Generic, Argument, Constructor, NoArguments, Product, Sum, from)
import Data.Symbol (class IsSymbol)
import Foreign (Foreign, unsafeToForeign)
import Hby.Task (Task)
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL
import Type.Prelude (reflectSymbol)
import Type.Proxy (Proxy(..))

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

---------------------------------------------
getValueTypeProxy :: forall a. a -> Proxy a
getValueTypeProxy _ = Proxy

---------------------------------------------
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

valueTypeToTsType :: forall a b. GenTypeProxyToTsType a => Generic b a => String -> b -> String
valueTypeToTsType name a = "export type " <> name <> " = " <> genTypeProxyToTsType (getValueTypeProxy (from a))
