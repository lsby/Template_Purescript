module Lib.DB where

import Hby.Task (Task)

foreign import get_xs_by_id :: Int -> Task (Array { "姓名" :: String })
