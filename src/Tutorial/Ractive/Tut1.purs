module Tutorial.Ractive where

import Debug.Trace
import Control.Monad.Eff
import Control.Monad.Eff.Ractive

tutorial1 :: Eff (trace :: Trace, ractiveM :: RactiveM) Ractive -> Eff (trace :: Trace, ractiveM :: RactiveM) Unit
tutorial1 eff = do
  trace "Tutorial 1 starting"
  trace "Tutorial 1 Done"
