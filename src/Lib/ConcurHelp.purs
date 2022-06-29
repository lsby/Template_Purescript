module Lib.ConcurHelp where

import Prelude
import Concur.Core (Widget)
import Concur.React (HTML)
import Control.Alt ((<|>))
import Data.Array (cons, find, fold, length, mapWithIndex, sortBy)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..), fst, snd)
import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Effect.Ref (Ref)
import Effect.Ref as Ref

waitAll :: forall a. Array (Widget HTML a) -> Widget HTML (Array a)
waitAll arr = do
  ref <- liftEffect $ (Ref.new [] :: Effect (Ref (Array (Tuple Int a))))
  [] <$ fold (mapWithIndex (getLoopWidget ref) arr) <|> waitAllData ref
  where
  getLoopWidget ref i w = do
    x <- w
    r <- liftEffect $ Ref.read ref
    case find (\a -> fst a == i) r of
      Just _ -> pure unit
      Nothing -> liftEffect $ Ref.write (cons (Tuple i x) r) ref
    getLoopWidget ref i w
  waitAllData ref = do
    r <- liftEffect $ Ref.read ref
    let len = length r
    if (length arr /= len) then do
      liftAff $ delay $ Milliseconds 100.0
      waitAllData ref
    else pure $ map snd (sortBy (\a b -> if fst a > fst b then GT else LT) r)
