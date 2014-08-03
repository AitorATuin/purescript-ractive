module Main where

import Control.Monad.Eff
import Control.Monad.Eff.Ractive
import Debug.Trace
import Control.Apply ((*>),(<*))
import Control.Bind ((>=>))

type Tut4Data = {
  greeting :: String,
  name :: String,
  color :: String,
  size :: Number,
  font :: String}

ractive4 :: Tut4Data -> RactiveEff Ractive
ractive4 = ractive "#template" "ractive-ps4"

setValue :: forall a. String -> a -> Ractive  -> RactiveEff Ractive
setValue fieldName fieldValue = set fieldName fieldValue

setColor :: String -> Ractive -> RactiveEff Ractive
setColor = setValue "color"

setGreeting :: String -> Ractive -> RactiveEff Ractive
setGreeting = setValue "greeting"

setName :: String -> (Ractive -> RactiveEff Ractive)
setName = setValue "name"

setSize :: Number -> (Ractive -> RactiveEff Ractive)
setSize = setValue "size"

setFont :: String -> (Ractive -> RactiveEff Ractive)
setFont = setValue "font"

changeText :: forall e. Ractive -> Eff (ractiveM :: RactiveM | e) Ractive
changeText =
  setGreeting "Hola" >=>
  setName "Mundo" >=>
  setColor "purple" >=>
  setFont "Georgia" >=>
  setSize 6

execute1Fn :: Ractive -> Eff (trace :: Trace, ractiveM:: RactiveM) Unit
execute1Fn r = changeText r *> trace "on-click:execute1 executed"

tut4 = do
  r <- ractive4 {
    greeting : "Hej, hej",
    name : "Värld",
    color: "black",
    font: "monospace",
    size: 2}
  on "execute1" execute1Fn r
  trace "Ractive activated!"
