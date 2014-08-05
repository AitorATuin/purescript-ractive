module Tutorial.Ractive where

import Debug.Trace
import Control.Monad.Cont.Trans
import Control.Monad.Eff
import Control.Monad.Eff.Ractive
import Data.Tuple (zip)
import Data.Array (range, length, map)
import qualified Data.Map as M

data Tutorial a eff = Tutorial String (TutorialPartials -> ContT Unit (Eff eff) a)
tutorialName :: forall a e. Tutorial a  e -> String
tutorialName (Tutorial name _) = name
tutorialFn :: forall a e. Tutorial a e -> TutorialPartials -> ContT Unit (Eff e) a
tutorialFn (Tutorial _ fn) = fn

type TutorialFn = forall e. TutorialPartials -> ContT Unit (Eff (trace :: Trace, ractiveM :: RactiveM | e)) Unit
type TutorialTyp = forall e. Tutorial Unit (trace :: Trace, ractiveM :: RactiveM | e)

type Template = String

type TutorialPartials = {
  outputP  :: Template,
  contentP :: Template}

ractiveTemplate = "#ractive-template"
ractiveElement = "ractive-element"

createRactive :: forall a. TutorialPartials -> { |a}  -> RactiveEff Ractive
createRactive partials d = ractiveFromData {template: ractiveTemplate,
  el: ractiveElement,
  partials: partials,
  "data": d}

mapOfTutorials :: forall e. M.Map String  (Tutorial Unit (trace :: Trace, ractiveM :: RactiveM | e))
mapOfTutorials = M.fromList $ flip zip listOfTutorials $ tutName <$> listOfTutorials
  where
    tutName (Tutorial name f) = name

-- Tutorial 1
tutorial1 :: TutorialTyp
tutorial1 = Tutorial "tut1" tutorial1Fn

-- Rerenders a partial using a 'flag'.
--   + see: https://github.com/ractivejs/ractive/issues/236
tutorial1Run1 :: TutorialPartials -> Ractive -> Event -> Eff (trace::Trace,ractiveM::RactiveM) Unit
tutorial1Run1 partials r event = do
  set "showOutput" false r
  setPartial "outputP" partials.outputP r
  set "showOutput" true r

tutorial1Fn :: TutorialFn
tutorial1Fn partials = ContT \_ -> do
  trace "Tutorial 1 starting"
  r <- createRactive {outputP: "", contentP: partials.contentP} {}
  on "run1" (tutorial1Run1 partials) r
  trace "Tutorial 1 Done"

-- Tutorial 2
tutorial2Run1 partials r event = do
  set "showOutput" false r
  setPartial "outputP" partials.outputP r
  set "showOutput" true r

tutorial2Fn :: TutorialFn
tutorial2Fn partials = ContT \_ -> do
  trace "Tutorial 2 Starting"
  r <- createRactive partials {name: "Värld", greetings:"Hej, hej"}
  on "run1" (tutorial2Run1 partials) r
  trace "Tutorial 2 Done"

tutorial2 = Tutorial "tut2" tutorial2Fn

-- List of Tutorials
listOfTutorials :: forall e. [Tutorial Unit (trace :: Trace, ractiveM :: RactiveM | e)]
listOfTutorials = [tutorial1, tutorial2]
