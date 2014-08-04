module Tutorial.Ractive.Tutorial.Demo where

import Control.Monad.Eff
import qualified Control.Monad.Eff.Ractive as Ract
import Debug.Trace
import Control.Apply ((*>),(<*))
import Control.Bind ((>=>))
import Control.Monad.Trans
import Control.Monad.Cont.Trans
import Data.Maybe
import Network.HTTP
import Network.XHR
import Tutorial.Ractive.Tutorial

tutorialPartials :: Template -> Template -> TutorialPartials
tutorialPartials output content = {output: output, content: content}

type TutorialConfig = {
  contentTemplate :: URI,
  outputTemplate :: URI,
  element :: String,
  template :: String}

template :: String -> String -> URI -> URI -> TutorialConfig
template element template baseUri dir = {contentTemplate: content, outputTemplate: output, element: element, template: template}
  where
    content = baseUri ++ "/" ++ dir ++ "/" ++ "content.html"
    output  = baseUri ++ "/" ++ dir ++ "/" ++ "output.html"

templateTuto :: URI -> TutorialConfig
templateTuto = template ractiveElement ractiveTemplate "http://localhost/templates"

templateTuto1 :: TutorialConfig
templateTuto1 = templateTuto "tut1"

getFrom :: forall r. URI -> (RequestConfig r -> EffXHR r Unit)
getFrom url = (flip $ flip get url) {}

getTemplate :: forall e a b. (String -> a -> b) -> URI -> a -> ContT Unit (Eff (xhr::XHR | e)) b
getTemplate fun uri = \v ->
  ContT \next -> do
    getFrom uri $ defaultConfig {onLoadEnd = \response -> next $ fun (responseText response) v}

outputPartialTut :: forall e. URI -> Unit -> ContT Unit (Eff (xhr::XHR | e)) (String -> TutorialPartials)
outputPartialTut = getTemplate \tmpl ->
  \_ -> tutorialPartials tmpl

contentPartialTut :: forall e. URI -> (String -> TutorialPartials) -> ContT Unit (Eff (xhr::XHR | e)) TutorialPartials
contentPartialTut = getTemplate \tmpl ->
  \fun -> fun tmpl

--ractiveTut2 partials

loadTutorial :: forall e. TutorialConfig -> Unit -> ContT Unit (Eff (ractiveM::Ract.RactiveM,xhr::XHR | e)) TutorialPartials
loadTutorial config = outputPartialTut
  config.outputTemplate >=>
  contentPartialTut config.contentTemplate

launch :: forall a e. Tutorial a (xhr :: XHR, trace :: Trace, ractiveM :: Ract.RactiveM | e) -> Eff (xhr :: XHR, trace :: Trace, ractiveM :: Ract.RactiveM | e) Unit
launch (Tutorial name tutorialF) = runContT (executeTutorial unit) $ \r ->
  trace "DONE"
  where
    executeTutorial = loadTutorial (templateTuto name) >=> tutorialF

init = do
  r <- Ract.ractive "#ractive-nav-template" "ractive-nav" {tutorials: tutorials}
  flip (Ract.on "loadtutorial") r \r -> do
    launch tutorial1
  trace "Initialization done"
