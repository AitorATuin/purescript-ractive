module Tutorial.Ractive.Demo.Tutorials where

import Debug.Trace
import Control.Monad.Cont.Trans
import Control.Monad.Eff
import Control.Monad.Eff.Ractive

data Tutorial a eff = Tutorial String (Ractive -> ContT Unit (Eff eff) a)

tutorials = [{"name": "tut1"},{"name": "tut2"}]

tutorial1 :: Tutorial Unit (trace :: Trace, ractiveM :: RactiveM)
tutorial1 = Tutorial "tut1" tutorial1Fn

tutorial1Fn :: Ractive -> ContT Unit (Eff (trace :: Trace, ractiveM :: RactiveM)) Unit
tutorial1Fn ractive = ContT \_ -> do
  trace "Tutorial 1 starting"
  set "d" "d" ractive
  trace "Tutorial 1 Done"
