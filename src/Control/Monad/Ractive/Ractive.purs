module Control.Monad.Eff.Ractive where

import Control.Monad.Eff
import Data.Foreign.EasyFFI

-- TODO: How to restrict values a of type String?
type Data a b = {
  template :: String,
  el :: String,
  partials :: { | a},
  "data" :: { | b}}

type Event = {node :: DOMNode,
  original :: DOMEvent,
  keypath :: String,
  context :: {name :: String}}

foreign import data DOMEvent :: *

foreign import data DOMNode :: *

foreign import data RactiveM :: !

foreign import data Ractive :: *

type RactiveEff a = forall e. Eff (ractiveM :: RactiveM | e) a

ffiF = unsafeForeignFunction
ffiP = unsafeForeignProcedure

ractive :: forall a. String -> String -> a -> RactiveEff Ractive
ractive = ffiF ["template", "document", "data", ""] "new Ractive({template:template, el: document, data:data})"

ractiveFromData :: forall a b. Data a b -> RactiveEff Ractive
ractiveFromData = ffiF ["data", ""] "new Ractive(data);"

get :: forall a. String -> Ractive -> RactiveEff a
get = ffiF ["field", "ractive", ""] "ractive.get(field)"

-- TODO: Add support for setting objects {}
--set :: forall a. String -> a -> Ractive -> RactiveEff Ractive
--set = ffiF ["selector", "value", "ractive", ""]
  "function () { ractive.set(selector, value); return ractive}()"
foreign import set
  "function set(selector) {\
  \ return function(value) {\
  \   return function(ractive) { \
  \     return function () {\
  \     ractive.set(selector, value); \
  \   } \
  \ }\
  \}}" :: forall a. String -> a -> Ractive -> RactiveEff Unit

foreign import setPartial
  "function setPartial(selector) {\
  \  return function (value) {\
  \    return function (ractive) {\
  \      return function () {\
  \        ractive.partials[selector] = value; \
  \}}}}" :: String -> String -> Ractive -> RactiveEff Unit

foreign import getPartial
  "function getPartial(selector) {\
  \ return function(ractive) {\
  \   return function () {\
  \     return ractive.partials[selector]; \
  \   } \
  \  } \
  \}" :: String -> Ractive -> RactiveEff String

foreign import on
   "function on(event) {\
   \  return function(handler) { \
   \    return function(ractive) { \
   \      return function() { \
   \        ractive.on(event, function(ev) { \
   \          return handler(this)(ev)(); \
   \        }); \
   \        return ractive; \
   \      } \
   \    } \
   \  } \
   \}" :: forall a e. String -> (Ractive -> Event -> Eff e a) -> Ractive -> RactiveEff Ractive
