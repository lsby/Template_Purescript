module Component.Clock where

import Prelude
import Concur.Core (Widget)
import Concur.React (HTML)
import Concur.React.DOM as D
import Control.Alt ((<|>))
import Effect.Aff (Milliseconds(..), delay)
import Effect.Aff.Class (liftAff)

main :: forall a. Int -> Widget HTML a
main n = do
  D.text (show n) <|> (liftAff $ delay $ Milliseconds 1000.0)
  main $ n + 1
