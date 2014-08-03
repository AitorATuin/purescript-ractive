module Main where

import Control.Monad.Eff
import Control.Monad.Eff.Ractive
import Debug.Trace
import Control.Apply ((*>))

--type myData = {}

--tut1Ractive :: Ractive {}
--tut1Ractive = RactiveD {
--  template: "<div>Hello World</div>",
--  el: "ractive-ps1"} {}

tut3Ractive :: RactiveEff Ractive
tut3Ractive = ractive "#template" "ractive-ps3" {greeting: "Hej, hej", name: "Värld"}

changeGreeting :: RactiveEff Ractive
changeGreeting = tut3Ractive >>= set "name" "Mundo" >>= set "greeting" "Hola"

execute1Fn ::  Ractive -> Eff (trace :: Trace, ractiveM :: RactiveM) Unit
execute1Fn _ = changeGreeting *> trace "on-click:execute1 executed!"
-- >>= do
--  trace "on-click:execute1 executed!"

tut3 = do
  r <- tut3Ractive
  on "execute1" execute1Fn r
  trace "Ractive activated!"
