module Electron where

import Prelude

import Data.Argonaut (Json)
import Data.Argonaut (encodeJson, decodeJson) as A
import Data.Array (length)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Hby.Electron.App (onActivate, onWindowAllClosed, quit, whenReady)
import Hby.Electron.BrowserWindow (getAllWindows, getWebContents, loadFile, loadURL, newBrowserWindow)
import Hby.Electron.Data (BrowserWindowConf, IpcMainEvent)
import Hby.Electron.IPCMain (on)
import Hby.Electron.IpcMainEvent (reply, setReturnValue)
import Hby.Electron.WebContents (openDevTools)
import Hby.Task (Task, runTask_)
import Hby.Task as T
import Lib.Lib as Lib
import Node.Globals (__dirname)
import Node.Path (resolve)
import Node.Platform (toString)
import Node.Process (lookupEnv, platform)

main :: Effect Unit
main =
  runTask_ do
    Lib.initEnv
    whenReady
    createWindow
    onActivate onAllCloseCreate
    onWindowAllClosed setDarwinPlatform
    setIPCEvent
  where
  bwConf :: Task BrowserWindowConf
  bwConf = do
    p <- liftEffect $ resolve [ __dirname ] "../../dist/preload.js"
    pure
      { width: 800.0
      , height: 600.0
      , resizable: false
      , webPreferences:
          { contextIsolation: false
          , preload: p
          }
      }

  createWindow :: Task Unit
  createWindow = do
    conf <- bwConf
    bw <- newBrowserWindow conf
    wc <- pure $ getWebContents bw
    env <- liftEffect $ lookupEnv "NODE_ENV"
    pure unit
    case env of
      Just "development" -> do
        T.log "开发模式启动"
        loadURL bw "http://localhost:1234"
      _ -> do
        T.log "生产模式启动"
        p <- liftEffect $ resolve [ __dirname ] "../../dist/index.html"
        loadFile bw p
    openDevTools wc

  setDarwinPlatform :: Task Unit
  setDarwinPlatform = case platform of
    Nothing -> pure unit
    Just p -> case toString p of
      "darwin" -> pure unit
      _ -> quit

  onAllCloseCreate :: Task Unit
  onAllCloseCreate = do
    arr <- getAllWindows
    case length arr of
      0 -> createWindow
      _ -> pure unit

  setIPCEvent :: Task Unit
  setIPCEvent = do
    on "testSync" testSync
    on "testAsync" testAsync

----------------------
testSync :: IpcMainEvent → Json → Task Unit
testSync e a = do
  case A.decodeJson a of
    Left err -> do
      T.log $ show err
    Right (rx :: { msg :: String }) -> do
      T.log $ show rx
      setReturnValue e $ A.encodeJson { msg: "testSync-toWeb" }

testAsync :: IpcMainEvent → Json → Task Unit
testAsync e a = do
  case A.decodeJson a of
    Left err -> do
      T.log $ show err
    Right (rx :: { msg :: String }) -> do
      T.log $ show rx
      reply e "testAsync-reply" $ A.encodeJson { msg: "testSync-toWeb" }
