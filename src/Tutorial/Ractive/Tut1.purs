module Tutorial.Ractive.Tutorial where

import Debug.Trace
import Control.Monad.Cont.Trans
import Control.Monad.Eff
import Control.Monad.Eff.Ractive

data Tutorial a eff = Tutorial String (TutorialPartials -> ContT Unit (Eff eff) a)

type TutorialFn = forall e. TutorialPartials -> ContT Unit (Eff (trace :: Trace, ractiveM :: RactiveM | e)) Unit

type Template = String

type TutorialPartials = {
  output  :: Template,
  content :: Template}

ractiveTemplate = "#ractive-template"
ractiveElement = "ractive-element"

tutorials = [{"name": "tut1"},{"name": "tut2"}]

createRactive :: forall a. TutorialPartials -> { |a}  -> RactiveEff Ractive
createRactive partials d = ractiveFromData {template: ractiveTemplate,
  el: ractiveElement,
  partials: partials,
  "data": d}

tutorial1 :: forall e. Tutorial Unit (trace :: Trace, ractiveM :: RactiveM | e)
tutorial1 = Tutorial "tut1" tutorial1Fn

tutorial1Fn :: TutorialFn
tutorial1Fn ractive = ContT \_ -> do
  trace "Tutorial 1 starting"
  trace "Tutorial 1 Done"

-- Tutorial 2
tutorial2Fn :: TutorialFn
tutorial2Fn partials = ContT \_ -> do
  r <- createRactive partials {}
  trace "test"
