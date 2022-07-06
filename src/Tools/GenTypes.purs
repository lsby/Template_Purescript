module Tools.GenTypes where

import Prelude

import Data.Foldable (intercalate)
import Effect (Effect)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (writeTextFile)
import Node.Globals (__dirname)
import Node.Path as PATH
import OhYes (generateTS)
import Text.Prettier (defaultOptions, format)
import Type.Proxy (Proxy(..))
import Web (State, Event)

-- | 生成前端状态和事件的TS类型描述
-- | 注意: 不要生成泛型类型, 在TS里无法完整表达完整的类型约束, 应当将其包裹为特化类型.
-- | 注意: 尽可能生成Pure类型, 使TS无法操作, 以保证安全.
genTypes :: Effect Unit
genTypes = do
  p <- PATH.resolve [ __dirname ] "../../src/Page/Types.ts"
  writeTextFile UTF8 p values
  where
  values = format defaultOptions $ intercalate "\n"
    [ generateTS "WebState" (Proxy :: Proxy State)
    , generateTS "WebEvent" (Proxy :: Proxy Event)
    ]
