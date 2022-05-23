module Component.Hello where

import Prelude
import Concur.Core (Widget)
import Concur.React (HTML)
import Concur.React.DOM as D
import Concur.React.Props as P

main :: forall a. Widget HTML a
main = do
  _ <- D.button [ P.onClick ] [ D.text "点一下按钮" ]
  D.div' [ D.text "就会到这里" ]
