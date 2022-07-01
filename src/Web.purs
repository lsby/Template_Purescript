module Web where

import Prelude

import Data.Foldable (intercalate)
import Effect (Effect)
import Effect.Console (log)
import Hby.Task (Task)
import Lib.Vue (VueReactive)
import Lib.Vue as V
import Node.Encoding (Encoding(..))
import Node.FS.Sync (writeTextFile)
import Node.Globals (__dirname)
import Node.Path as Path
import OhYes (generateTS)
import Text.Prettier (defaultOptions, format)
import Type.Proxy (Proxy(..))

----------------------
generateTSType :: Effect Unit
generateTSType = do
  p <- (Path.resolve [ __dirname, "../../src/Page/" ] "types.ts")
  writeTextFile UTF8 p values
  where
  values = format defaultOptions $ intercalate "\n"
    [ generateTS "state" (Proxy :: Proxy State)
    , generateTS "event" (Proxy :: Proxy Event)
    ]

----------------------
type State =
  { a :: Int
  , b :: String
  }

state :: VueReactive State
state = V.mk
  { a: 1
  , b: "abc"
  }

----------------------
hello :: Effect Unit
hello = log "hello, world."

myAdd :: Int -> Int -> Int
myAdd a b = a + b

increase :: VueReactive State -> Task Unit
increase ref = do
  V.set (Proxy :: Proxy "a") 3 ref

type Event =
  { increase :: Task Unit
  }

event :: VueReactive Event
event = V.mk
  { increase: increase state
  }
