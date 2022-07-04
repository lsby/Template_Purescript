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

genTypes :: Effect Unit
genTypes = do
  p <- PATH.resolve [ __dirname ] "../../src/Page/Types.ts"
  writeTextFile UTF8 p values
  where
  values = format defaultOptions $ intercalate "\n"
    [ generateTS "WebState" (Proxy :: Proxy State)
    , generateTS "WebEvent" (Proxy :: Proxy Event)
    ]
