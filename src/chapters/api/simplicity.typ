#import "/src/util.typ": *
#import mantys: *

= Simplicity <sec:api:simple>
Good APIs should be simple, easy to use and aware of their primary use case. Flexibility as discussed in @sec:api:flex should not interfere with the usability of an API.

== Higher Order Templates
A common pattern for Typst templates is to provide a single top level function, which a user imports and applies with a show-all rule, i.e. `show: func`.
This makes for a simple API in the case of no arguments, but requires extra thought when arguments have to be applied.
This idiom also comes with additional boilerplate in almost any template, templates are almost never applied without any arguments.
By using functions as values, a template author can provide a simpler API for the most common use case of applying this function as a template.

Consider returning a function which is applied in the show-all rule from your template function, instead of taking the content itself.

#do-dont[
  ```typst
  #let doc(..args) = body => {
    // .. use args
    body
  }
  ```
][
  ```typst
  #let doc(..args, body) = {
    // .. use args
    body
  }
  ```
]

What was previously this:
#codesnippet(
  ```typst
  #import "@preview:template:0.1.0": doc
  #show: doc.with(..args)
  ```
)

Can now be used like this:
#codesnippet(
  ```typst
  #import "@preview:template:0.1.0": doc
  #show: doc(..args)
  ```
)

This also comes with the benefit of being future proof, as current discussions on the #discord[Typst Community Discord] indicate that templates will likely be sets of rules instead of functions in the future.
A template using this idiom can then simply return the styles instead of a function, requiring no other change from a downstream user.
