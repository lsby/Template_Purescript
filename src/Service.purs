module Service where

import Prelude

import Data.Argonaut (encodeJson, decodeJson) as A
import Data.Either (Either(..))
import Data.Int (fromNumber)
import Data.Maybe (Maybe(..))
import Data.Number (fromString)
import Effect (Effect)
import Effect.Class (liftEffect)
import Hby.Express.Express (appB, listen, middle_cookieParser, middle_json, middle_urlencoded, mkApp, useMiddle, useRoute, useStatic, Route, mkRoute, routeB, setPost, Req, Res, getBody, send)
import Hby.Task (Task, log, runTask_, throw)
import Lib.InitEnv (initEnv)
import Node.Globals (__dirname)
import Node.Path (resolve)
import Node.Process (lookupEnv)

main :: Effect Unit
main =
  runTask_ do
    initEnv
    staticPath <- liftEffect $ resolve [ __dirname ] "../../dist"
    apiRoute <- api
    app <-
      mkApp
        <<< useMiddle middle_json
        <<< useMiddle middle_urlencoded
        <<< useMiddle middle_cookieParser
        <<< useStatic "/" staticPath
        <<< useRoute "/api" apiRoute
        $ appB
    port <- liftEffect $ lookupEnv "APP_PORT"
    case port >>= fromString >>= fromNumber of
      Nothing -> throw "无法从环境变量获得端口号"
      Just p -> listen app p $ log $ "start service in http://127.0.0.1:" <> show p

api :: Task Route
api =
  mkRoute
    <<< setPost "/add" onAdd
    $ routeB

onAdd :: Req -> Res -> Task Unit
onAdd req res = do
  case A.decodeJson (getBody req) of
    Left err -> do
      log $ show err
      send res $ A.encodeJson { err: show err }
    Right (rx :: { a :: Number, b :: Number }) -> do
      log "收到了请求"
      send res $ A.encodeJson { err: unit, data: rx.a + rx.b }
