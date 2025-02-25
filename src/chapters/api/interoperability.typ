#import "/src/util.typ": *
#import mantys: *

= Interoperability
Ensuring interoperability between packages is an important part of API design.
Lack of interoperability, especially when it leads to bugs or panics will generally lead users to shy away from using one of the packages which are incompatible.
When designing the API of your package, the following two questions should be considered for every item of your package's API:

- should this item be public or private?
- should this behavior be configurable?

The choice to make an item private or part of a function's behavior hardcoded can negatively impact it's interoperability, but the opposite can lead to bloated and intimidating APIs.
Depending on the target audience of your package you may chose one over the other.
Developers may require APIs with more configurable parameters while end users may just want a simple to use API that doesn't get in their way.

== Visibility
In order to provide other package authors with the ability to write extensions to your package they must usually be able to access certain internals of your package.
The internals of your package can be exposed in different ways.
They can be exposed as public items which are undocumented or marked as unstable.
Or they can be exposed fully documented and stable but marked as internal or advanced.
How and if they are exposed depends on your package's use cases and target audience.

#wbox[
  At the time of writing this Typst 0.11.1 doesn't support controlling the visibility of items directly.
]

To mark an item private, consider simply prefixing it with an underscore like `_internal-func`.
While it is not technically unreachable for a user, it is declared as discouraged to use and generally considered unstable, i.e. not part of the stability guarantees of your API.
To truly make an item private it must be declared in a scope deeper than the top level of a module, such as inside a function or block expression without being returned from such a scope.

```typst
// public and stable
#let func() = { ... }

// reachable for a user if needed
#let _internal-func() = { ... }

#let exposed = {
  // unreachable to anyone outside this module
  let truly-internal() = { ... }

  // public and stable by virtue of its "re-export"
  let func() = { ... }

  func
}
```

== Flexibility
Allowing a user to configure how your API behaves is important to ensure it's flexibility and aids in supporting use cases you may not have anticipated.
For example, given a function which queries for and styles elements before a certain label, consider making the label configurable, especially if it is otherwise exposed to the user (like through a helper function which places this label for them).

#do-dont[
  ```typst
  #let func(label: <x>) = {
    let selector = internal.func()
    internal.display(query(selector.before(label)))
  }
  ```
][
  ```typst
  #let func() = {
    let selector = internal.func()
    // this label can not be configured, if the internal APIs are not exposed a
    // user may not be abel to use this at all
    internal.display(query(selector.before(<x>)))
  }
  ```
]

An example of both exposed internals and configurable behavior allowing interoperability is the #mty.package[Fletcher] package, which builds on #mty.package[CeTZ].
#mty.package[Fletcher] exposes a simplified API to draw diagrams of all kinds involving arrows.
In order to allow users to draw anything the package itself may not natively support, #mty.package[Fletcher] allows accessing all resolved coordinates and items before they are passed to #mty.package[CeTZ] for drawing.

See @sec:api:flex for more guidelines on flexibility.

```typst
#fletcher.diagram(
  ...,
  render: (grid, nodes, edges, options) => cetz.canvas({
    // additional non standard drawing or adjustments can be done here
    fletcher.draw-diagram(grid, nodes, edges, debug: options.debug)
  }),
)
```

== Naming of Global Introspection Elements
For keys of states and counters, the use of unique identifiers prevents clashes with other packages or identifiers chosen by an end user.
If your package is likely to be included more than once in the tree of dependencies a version mismatch between these instances is also possible.
Consider using a unique key across multiple versions of your package.

An example of a unique key would be the following grammar:
```ebnf
key ::= '__' package-name [ ':' package-version ] ':' package-unique-key
```

The leading double underscores `__` ensure that the following key is unlikely to be accidentally used by an end user themselves.
A package `pkg` with the version `0.1.0` would only operate on states or counters using keys with the prefix `__pkg:0.1.0`, this automatically prevents possible version incompatible changes of the internal state representation.
A package may decide if it omits this or maintains a representation which is consistent across multiple versions, using a different mechanism to mark where these are no longer compatible.
The package unique key is unique within the package and can be freely chosen.

Similarly to the keys of counters and states, labels also share a global namespace, once put into the document.
Consider a similar approach for these labels, as well as using names invalid for `@ref` syntax, this ensures that LSPs do not pollute label completions with values which are not meant to be referred to by a user.
An example of this is including whitespace or other non-identifier characters in the key.
A key like `__ pkg:0.1.0:label:backref-anchor` (notice the space after the double underscores) cannot be used in `@ref` syntax and will therefore not be suggested as a completion.

== Examples and Import Conventions
If your package documentation or README contains examples, consider keeping import statements simple in order to not pollute namespaces with possibly conflicting symbols.
Avoid glob imports (`import x: *`) in the file scope.

#do-dont[
  ```typst
  // no glob import, it's clear which items are declared where
  #import "@preview/fletcher:0.5.0": edge, node, diagram
  #diagram({
    // ...
  })


  #import "@preview/cetz:0.5.0": canvas, draw
  #canvas({
    // glob import is scoped to a section which almost exclusively uses cetz
    // items
    import draw: *
    // ...
  })
  ```
][
  ```typst
  // glob import, it's not clear which items are declared where
  #import "internal.typ": diagram
  #import "@preview/fletcher:0.5.0": *
  #diagram({
    // ...
  })
  ```
]
