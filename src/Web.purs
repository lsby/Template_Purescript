module Web where

import Prelude

import Data.Argonaut as A
import Data.Either (Either(..))
import Hby.Electron.IPCRenderer (on, send, sendSync)
import Hby.Task (Task)
import Hby.Task as T
import Lib.Lib as Lib
import Lib.Vue (VueReactive)
import Lib.Vue as V
import Model.Counter (Counter(..))
import Model.Counter as Counter

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
    , testElectronSync: Lib.testElectronSync
    , testElectronAsync_on: Lib.testElectronAsync_on
    , testElectronAsync_send: Lib.testElectronAsync_send
    }

----------------------
increase :: State -> State
increase s = s { n = Counter.add 1 s.n }

makeZero :: State -> State
makeZero s = s { n = Counter 0 }
