module Web where

import Prelude

import Data.Foldable (intercalate)
import Effect (Effect)
import Hby.Task (Task)
import Lib.LibWeb as LibWeb
import Lib.Vue (VueReactive)
import Lib.Vue as V
import Model.Counter (Counter(..))
import Model.Counter as Counter
import Node.Encoding (Encoding(..))
import Node.FS.Sync (writeTextFile)
import Node.Globals (__dirname)
import Node.Path as PATH
import OhYes (generateTS)
import Text.Prettier (defaultOptions, format)
import Type.Proxy (Proxy(..))

----------------------
genTypes :: Effect Unit
genTypes = do
  p <- PATH.resolve [ __dirname ] "../../src/Page/Types.ts"
  writeTextFile UTF8 p values
  where
  values = format defaultOptions $ intercalate "\n"
    [ generateTS "WebState" (Proxy :: Proxy State)
    , generateTS "WebEvent" (Proxy :: Proxy Event)
    ]

----------------------
type State =
  { n :: Counter
  , hello :: String
  }

state :: Task (VueReactive State)
state = V.mk
  { n: Counter 0
  , hello: "hello, world!"
  }

----------------------
type Event =
  { increase :: Task Unit
  , makeZero :: Task Unit
  , testElectronSync :: Task Unit
  , testElectronAsync_on :: Task Unit
  , testElectronAsync_send :: Task Unit
  }

event :: Task (VueReactive Event)
event = do
  s <- state
  V.mk
    { increase: V.apply increase s
    , makeZero: V.apply makeZero s
    , testElectronSync: LibWeb.testElectronSync
    , testElectronAsync_on: LibWeb.testElectronAsync_on
    , testElectronAsync_send: LibWeb.testElectronAsync_send
    }

----------------------
increase :: State -> Task State
increase s = pure $ s { n = Counter.add 1 s.n }

makeZero :: State -> Task State
makeZero s = pure $ s { n = Counter 0 }
