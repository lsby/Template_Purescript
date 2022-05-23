module Component.State where

import Prelude
import Concur.Core (Widget)
import Concur.React (HTML)
import Concur.React.DOM as D
import Concur.React.Props as P

c1 :: Int -> Widget HTML Int
c1 a =
  D.div'
    [ D.div' [ D.text (show a) ]
    , a + 1 <$ D.button [ P.onClick ] [ D.text "按钮" ]
    ]

type State
  = { a :: Int, b :: Int }

main :: forall a. State -> Widget HTML a
main s = do
  s' <-
    D.div'
      [ (\x -> s { a = x }) <$> D.div' [ c1 s.a ]
      , (\x -> s { b = x }) <$> D.div' [ c1 s.b ]
      , (\x -> s { a = x }) <$> D.div' [ c1 s.a ]
      ]
  main s'
