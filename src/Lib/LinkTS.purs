module Lib.LinkTS where

import Prelude

import Data.String (joinWith)
import Data.Symbol (class IsSymbol)
import Foreign (Foreign, unsafeToForeign)
import Hby.Task (Task)
import Prim.Row (class Cons, class Lacks)
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL
import Record (delete, get)
import Type.Prelude (reflectSymbol)
import Type.Proxy (Proxy(..))

class LinkTSRecordType :: RowList Type -> Constraint
class LinkTSRecordType a where
  linkTSRecordType :: Proxy a -> Array String

instance LinkTSRecordType RL.Nil where
  linkTSRecordType _ = []

instance (IsSymbol k, LinkTS v, LinkTSRecordType t) => LinkTSRecordType (RL.Cons k v t) where
  linkTSRecordType _ = [ reflectSymbol (Proxy :: Proxy k) <> ": " <> toTSType (Proxy :: Proxy v) ] <> linkTSRecordType (Proxy :: Proxy t)

class LinkTSRecordValue :: Row Type -> RowList Type -> Constraint
class LinkTSRecordValue row rowList | rowList -> row where
  linkTSRecordValue :: (RowToList row rowList) => Record row -> Foreign

instance LinkTSRecordValue () (RL.Nil) where
  linkTSRecordValue _ = unsafeToForeign unit

instance
  ( Cons k v tr row
  , IsSymbol k
  , LinkTS v
  , RowToList tr trList
  , LinkTSRecordValue tr trList
  , Lacks k tr
  ) =>
  LinkTSRecordValue row (RL.Cons k v tl) where
  linkTSRecordValue r = unsafeToForeign $
    { key: reflectSymbol (Proxy :: Proxy k)
    , value: toTSValue (get (Proxy :: Proxy k) r)
    , tail: linkTSRecordValue (delete (Proxy :: Proxy k) r)
    }

class LinkTS :: Type -> Constraint
class LinkTS a where
  toTSValue :: a -> Foreign
  toTSType :: Proxy a -> String

instance LinkTS Unit where
  toTSValue a = unsafeToForeign a
  toTSType _ = "{}"

instance LinkTS Int where
  toTSValue a = unsafeToForeign a
  toTSType _ = "number"

instance LinkTS Number where
  toTSValue a = unsafeToForeign a
  toTSType _ = "number"

instance LinkTS String where
  toTSValue a = unsafeToForeign a
  toTSType _ = "string"

instance LinkTS Boolean where
  toTSValue a = unsafeToForeign a
  toTSType _ = "boolean"

instance (LinkTS a) => LinkTS (Array a) where
  toTSValue a = unsafeToForeign (map toTSValue a)
  toTSType _ = "Array<(" <> toTSType (Proxy :: Proxy a) <> ")>"

instance (RowToList r rl, LinkTSRecordType rl, LinkTSRecordValue r rl) => LinkTS (Record r) where
  toTSValue a = unsafeToForeign $ trForeignRecordTsValue $ linkTSRecordValue a
  toTSType _ = "{" <> joinWith ", " (linkTSRecordType (Proxy :: Proxy rl)) <> "}"

instance (LinkTS a, LinkTS b) => LinkTS (a -> b) where
  toTSValue a = unsafeToForeign $ a
  toTSType _ = "(a:" <> toTSType (Proxy :: Proxy a) <> ") => " <> toTSType (Proxy :: Proxy b)

instance (LinkTS a) => LinkTS (Task a) where
  toTSValue a = unsafeToForeign a
  toTSType _ = "() => Promise<" <> toTSType (Proxy :: Proxy a) <> ">"

toTSTypeExp :: forall a. LinkTS a => String -> a -> String
toTSTypeExp name _ = "export type " <> name <> " = " <> toTSType (Proxy :: Proxy a)

foreign import trForeignRecordTsValue :: Foreign -> Foreign
