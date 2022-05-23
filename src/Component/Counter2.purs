module Component.Counter2 where

import Prelude
import Concur.Core (Widget)
import Concur.React (HTML)
import Concur.React.DOM as D
import Concur.React.Props as P

main :: forall a. Widget HTML a
main = helloWidgetS 0

helloWidgetS :: forall a. Int -> Widget HTML a
helloWidgetS n = do
  _ <- D.button [ P.onClick ] [ D.text (show n) ]
  helloWidgetS $ n + 1

data View
  = View Int HTML
