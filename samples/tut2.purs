module Main where

import Control.Monad.Eff
import Control.Monad.Eff.Ractive
import Debug.Trace

--type myData = {}

--tut1Ractive :: Ractive {}
--tut1Ractive = RactiveD {
--  template: "<div>Hello World</div>",
--  el: "ractive-ps1"} {}

tut2Ractive :: {greeting :: String, name :: String} -> RactiveEff Ractive
tut2Ractive = ractive "<div>{{greeting}} {{name}}</div>" "ractive-ps2"

tut2 = tut2Ractive {greeting: "Hej, hej", name: "Värld"}
