module Model.Web where

import Prelude

import Data.Newtype (class Newtype)

newtype Player = Player { hp :: Int, mp :: Int }

derive instance Newtype Player _

addHp :: Int -> Player -> Player
addHp n (Player p@{ hp }) = Player $ p { hp = hp + n }
