module Component.FFI.Button where

import Prelude
import Concur.React.DOM (El, el')
import React (ReactClass, unsafeCreateElement)
import React.DOM.Props (unsafeFromPropsArray)

foreign import _button :: forall a. ReactClass a

button :: El
button = el' (unsafeCreateElement _button <<< unsafeFromPropsArray)
