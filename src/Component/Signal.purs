module Component.Signal where

import Prelude
import Concur.Core (Widget)
import Concur.Core.FRP (Signal, display, dyn, loopS, loopW)
import Concur.React (HTML)
import Concur.React.DOM as D
import Concur.React.Props as P
import Effect.Aff (Milliseconds(..), delay)
import Effect.Aff.Class (liftAff)

main :: forall a. Widget HTML a
main = do
  dyn
    $ loopS 0 \n -> do
        display $ D.text (show n)
        n' <- incrementTicker n
        counterSignal n'

-- Counter
counterSignal :: Int -> Signal HTML Int
counterSignal init =
  loopW init
    $ \n ->
        D.div'
          [ n + 1 <$ D.button [ P.onClick ] [ D.text "+" ]
          , D.div' [ D.text (show n) ]
          , n - 1 <$ D.button [ P.onClick ] [ D.text "-" ]
          ]

-- Timer
incrementTicker :: Int -> Signal HTML Int
incrementTicker init =
  loopW init
    $ \n -> do
        liftAff $ delay $ Milliseconds 1000.0
        pure (n + 1)
