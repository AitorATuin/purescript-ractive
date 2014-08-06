# Tunning our great message to the world!
---

---

We are cool enough, we can show dynamically a nice greeting to everyone, but it would be nicer if spanish people could understand us when being polite.

That's what we are going to do now, we are going to change the content of our message.

The first thing to do is to change our beautiful but static template with something like this:

{{=<% %>=}}
```html
<h2 class="hello">{{greetings}} {{name}}</h2>
```
<%={{ }}=%>

Good! We have created two mustache delimiters which will be binded to the data in our ractive object.

Lets use this template to show our old but remarkable message.

The **PureScript** snippet to do this is the following:

```haskell
import Control.Eff.Ractive

main :: Eff (ractiveM :: RactiveM) Unit
main = ractive "template" "#document" {greeting: "Hej, hej", name: "Värld!"}
```

<button class="btn btn-primary" on-click="run1">run</button>

Ok, now we have the same behavior than before but being dynamic, we can change the value of `greeting` and `name` and ractive will update the view.

Let's see how to do that in **PureScript**:

```haskell
changeGreeting :: Ractive -> String -> String -> Eff (ractiveM :: RactiveM) Unit
changeGreeting ractive = do
  set "greeting" "Hola" ractive
  set "name" "Mundo" ractive
```

That function gets a __Ractive__ instance and sets new values `greeting` and `name`.

Try to run that function!

<button class="btn btn-primary" on-click="run2">run</button>

---
### The code in more detail!
---

Just like we did before with the first example, let's try to explain that small chunk of **purescript** code.


* First we load the module with ```import Control.Eff.Ractive```
* Then, we define function which the only interesting thing that it does is to create a new ractive object.
To create it we pass three arguments to the _ractive_ function, the first one is the template we want to use (our nice greeting here),
the second one is the element where we want to show the message (all the element's children will be replaced!) and finally an object
with the data we want to bind (more on this later.)
* Please note that creating an object is a side-effect, so not allowed in a pure functional language like **purescript**,
that's the reason why _ractive_ function returns an _forall eff. Eff(ractiveM :: RactiveM) Ractive_.
See this [post](http://www.purescript.org/posts/Eff-Monad/ "Handling Native Effects with the Eff Monad") for a more detailed explanation.

---
### Functions involved here (and types)
---

Let's see the only function we have used here: _ractive_ and the type of it (we are now functional programmers so we really care about types!)

* **_ractive_** :: forall a eff. String -> String -> a -> Eff (ractiveM :: RactiveM | e)
