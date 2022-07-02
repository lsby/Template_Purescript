module Web (state, event) where

import Prelude
import Data.Argonaut as A
import Data.Either (Either(..))
import Hby.Electron.IPCRenderer (on, send, sendSync)
import Hby.Task (Task)
import Hby.Task as T
import Lib.Vue (VueReactive)
import Lib.Vue as V
import Type.Proxy (Proxy(..))

----------------------
n :: Int
n = 0

hello :: String
hello = "hello, world!"

type State =
  { n :: Int
  , hello :: String
  }

state :: Task (VueReactive State)
state = V.mk
  { n: n
  , hello
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
    { increase: increase s
    , makeZero: makeZero s
    , testElectronSync: testElectronSync
    , testElectronAsync_on: testElectronAsync_on
    , testElectronAsync_send: testElectronAsync_send
    }

----------------------
add1 :: Int -> Int
add1 a = a + 1

increase :: VueReactive State -> Task Unit
increase ref = do
  V.over (Proxy :: Proxy "n") (add1) ref

makeZero :: VueReactive State -> Task Unit
makeZero ref = do
  V.set (Proxy :: Proxy "n") 0 ref

testElectronSync :: Task Unit
testElectronSync = do
  r <- sendSync "testSync" $ A.encodeJson { msg: "testSync-toService" }
  case A.decodeJson r of
    Left err -> do
      T.log $ show err
    Right (rx :: { msg :: String }) -> do
      T.log $ show rx

testElectronAsync_on :: Task Unit
testElectronAsync_on = on "testAsync-reply"
  ( \_ a -> do
      case A.decodeJson a of
        Left err -> do
          T.log $ show err
        Right (rx :: { msg :: String }) -> do
          T.log $ show rx
  )

testElectronAsync_send :: Task Unit
testElectronAsync_send = send "testAsync" $ A.encodeJson { msg: "testAsync-toService" }
