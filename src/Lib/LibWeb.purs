module Lib.LibWeb where

import Prelude

import Data.Argonaut as A
import Data.Either (Either(..))
import Hby.Electron.IPCRenderer (on, send, sendSync)
import Hby.Task (Task)
import Hby.Task as T

----------------------
-- | 测试函数
foreign import testFun :: Task Unit

----------------------
-- | 当点击同步测试按钮
onClick_SyncSendTest :: Task Unit
onClick_SyncSendTest = do
  r <- sendSync "testSync" $ A.encodeJson { msg: "testSync-toService" }
  case A.decodeJson r of
    Left err -> do
      T.log $ show err
    Right (rx :: { msg :: String }) -> do
      T.log $ show rx

-- | 当点击异步监听按钮
onClick_AsyncListener :: Task Unit
onClick_AsyncListener = on "testAsync-reply"
  ( \_ a -> do
      case A.decodeJson a of
        Left err -> do
          T.log $ show err
        Right (rx :: { msg :: String }) -> do
          T.log $ show rx
  )

-- | 当点击异步测试按钮
onClick_AsyncSendTest :: Task Unit
onClick_AsyncSendTest = send "testAsync" $ A.encodeJson { msg: "testAsync-toService" }
