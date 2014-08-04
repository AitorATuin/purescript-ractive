module Tutorial.Ractive.Main where

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
import Tutorial.Ractive

type Template = String

type TutorialPartials = {
  output  :: Template,
  content :: Template}

tutorialPartials :: Template -> Template -> TutorialPartials
tutorialPartials output content = {output: output, content: content}

type TutorialConfig = {
  contentTemplate :: URI,
  outputTemplate :: URI,
  element :: String,
  template :: String}

data Launcher = Launcher TutorialConfig
type TutorialConfigEff = Eff(xhr::XHR,ractiveM::Ract.RactiveM,trace::Trace)

ractiveTemplate = "#ractive-template"
ractiveElement = "ractive-element"

tutorials = [{"name": "tut1"},{"name": "tut2"}]

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
getTemplate fun uri = \v -> ContT \next -> do
  getFrom uri $ defaultConfig {onLoadEnd = \response -> next $ fun (responseText response) v}

outputPartialTut :: forall e. URI -> Unit -> ContT Unit (Eff (xhr::XHR | e)) (String -> TutorialPartials)
outputPartialTut = getTemplate \tmpl -> \_ -> tutorialPartials tmpl

contentPartialTut :: forall e. URI -> (String -> TutorialPartials) -> ContT Unit (Eff (xhr::XHR | e)) TutorialPartials
contentPartialTut = getTemplate \tmpl -> \fun -> fun tmpl

ractiveTut :: forall e. TutorialConfig -> TutorialPartials -> ContT Unit (Eff (ractiveM::Ract.RactiveM | e)) Ract.Ractive
ractiveTut config partials = ContT \next -> do
  r <- Ract.ractiveFromData {template: config.template,
    el: config.element,
    partials: {outputP: partials.output, contentP: partials.content}}
  next r
--  ractive <- Ract.ractive config.template config.element {}
--  Ract.setPartial "outputP" partials.output ractive
--  Ract.setPartial "contentP" partials.content ractive

loadTutorial :: forall e. TutorialConfig -> Unit -> ContT Unit (Eff (ractiveM::Ract.RactiveM,xhr::XHR | e)) Ract.Ractive
loadTutorial config = outputPartialTut config.outputTemplate >=> contentPartialTut config.contentTemplate >=> ractiveTut config

launch :: forall e. TutorialConfig -> Eff (trace :: Trace, ractiveM :: Ract.RactiveM, xhr :: XHR | e) Unit
launch tutorial = runContT (loadTutorial tutorial unit) $ \r ->
  trace "DONE"

init = do
  r <- Ract.ractive "#ractive-nav-template" "ractive-nav" {tutorials: tutorials}
  flip (Ract.on "loadtutorial") r \r -> do
    launch templateTuto1
    trace "Cargado"
  trace "Initialization done"
