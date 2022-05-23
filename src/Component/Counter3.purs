module Component.Counter3 where

import Prelude
import Concur.Core (Widget)
import Concur.React (HTML)
import Concur.React.DOM as D
import Concur.React.Props as P
import Effect.Class (liftEffect)
import Effect.Console (log)

main :: forall a. Widget HTML a
main = _main 0

_main :: forall a. Int -> Widget HTML a
_main count = do
  n <-
    D.div'
      [ D.p' [ D.text ("State: " <> show count) ]
      , D.button [ P.onClick ] [ D.text "Increment" ] $> count + 1
      , D.button [ P.onClick ] [ D.text "Decrement" ] $> count - 1
      ]
  liftEffect (log ("COUNT IS NOW: " <> show n))
  _main n
