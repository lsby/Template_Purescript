module Web where

import Prelude
import Component.Clock as Clock
import Component.Counter2 as Counter2
import Component.FFI.Button as FFI
import Component.Hello as Hello
import Component.Loop as Loop
import Component.Signal as Signal
import Component.State as State
import Concur.React.DOM as D
import Concur.React.Run (runWidgetInDom)
import Effect (Effect)

main :: Effect Unit
main =
  runWidgetInDom "app"
    $ D.div'
        [ D.div' [ Hello.main ]
        , D.div' [ D.text "=======" ]
        , D.div' [ Clock.main 0 ]
        , D.div' [ D.text "=======" ]
        , D.div' [ Signal.main ]
        , D.div' [ D.text "=======" ]
        , D.div' [ Counter2.main ]
        , D.div' [ D.text "=======" ]
        , D.div' [ Loop.main 0 ]
        , D.div' [ D.text "=======" ]
        , D.div' [ State.main { a: 0, b: 0 } ]
        , D.div' [ D.text "=======" ]
        , D.div' [ FFI.button [] [ D.text "组件按钮" ] ]
        ]
