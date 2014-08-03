module Main where

import Control.Monad.Eff
import Control.Monad.Eff.Ractive
import Debug.Trace

--type myData = {}

--tut1Ractive :: Ractive {}
--tut1Ractive = RactiveD {
--  template: "<div>Hello World</div>",
--  el: "ractive-ps1"} {}

tut1Ractive = ractive "<div>Hej, hej värld!</div>" "ractive-ps1" {}

tut1 = do
  trace "Before Trying to create the new Ractive"
  r <- tut1Ractive
  trace "Tut1 launching!!"
