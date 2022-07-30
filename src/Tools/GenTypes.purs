module Tools.GenTypes where

import Prelude

import Data.Foldable (intercalate)
import Effect (Effect)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (writeTextFile)
import Node.Globals (__dirname)
import Node.Path as PATH
import Text.Prettier (defaultOptions, format)
import ValueTypeToTsType (valueTypeToTsType)
import Web (event, state)

-- | 生成前端状态和事件的TS类型描述
genTypes :: Effect Unit
genTypes = do
  p <- PATH.resolve [ __dirname ] "../../src/Page/Types.ts"
  writeTextFile UTF8 p values
  where
  values = format defaultOptions $ intercalate "\n"
    [ valueTypeToTsType "WebState" state
    , valueTypeToTsType "WebEvent" event
    ]
