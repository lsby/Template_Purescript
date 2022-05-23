module Component.Loop where

import Prelude
import Concur.Core (Widget)
import Concur.React (HTML)
import Concur.React.DOM as D
import Concur.React.Props as P
import Control.Alt ((<|>))

c1 :: Int -> Widget HTML Int
c1 a = D.text (show a)

c2 :: Int -> Widget HTML Int
c2 n = D.button [ n + 1 <$ P.onClick ] [ D.text "按钮" ]

main :: forall a. Int -> Widget HTML a
main n = do
  n' <- c1 n <|> c2 n
  main n'
