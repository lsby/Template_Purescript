module Lib.LibWeb where

import Prelude
import Data.Argonaut as A
import Data.Either (Either(..))
import Hby.Electron.IPCRenderer (on, send, sendSync)
import Hby.Task (Task)
import Hby.Task as T

----------------------
foreign import testFun :: Task Unit

----------------------
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
