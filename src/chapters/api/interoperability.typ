#import "/src/util.typ": *
#import mantys: *

= Interoperability
Ensuring interoperability between packages is an important part of API design.
Lack of interoperability, especially when it leads to bugs or panics will generally cause users to shy away from using your package.
When designing the API of your package, the following two questions should be considered for every item of your package's API:

- should this item be public or private?
- should this behavior be configurable?

The choice to make an item private or part of a function's behavior hardcoded can negatively impact it's interoperability, but the opposite can lead to bloated and intimidating APIs.

== Visibility
In order to provide other package authors with the ability to write extensions to your package they must usually be able to access cerain internals of your package.
The internals of your package can be exposed in different ways.
They can be exposed as public items which are undocumented or marked as unstable.
They can be exposed fully documented and stable but as discouraged for the average user.
How and if they are exposed depends on the type of API your package provides and if you as the author deem it necessary or useful.

#wbox[
  At the time of writing this Typst 0.11.1 doesn't support controlling the visiblity of items directly.
]

To mark an item private, consider simply prefixing it with an underscore like `_internal-func`.
While it is not technically unreachable for a user, it is declared as discuraged to use and generally considered unstable, i.e. not part of the stability guarantees of your API.
To truly make an item pivate it must be declared in a scope deeper than the top level of a module, such as inside a function or block expression without being returned from such a scope.

```typst
// public and stable
#let func() = { ... }

// reachable for a user if needed
#let _internal-func() = { ... }

#let exposed = {
  // unreachable to anyone outside this module
  let truly-internal() = { ... }

  // public and stable by virture of "re-export"
  let func() = { ... }

  func
}
```

== Configurability
To allow a user to configure how your API behaves is important to ensure your API flexible, supporting usecases you may not have anticipated.
For example, given a function which queries for and styles elements before a certain label, consider making the label configurable, especially if it is otherwise exposed to the user.

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

An example of both exposed internals and configrable behavior allowing interoperability is the #mty.package[Fletcher] package, which builds on #mty.package[Cetz].
#mty.package[Fletcher] exposes a simplified API to draw diagrams of all kinds involving arrows.
In order to allow users to draw anything the package itself my not natively support, #mty.package[Fletcher] allows accessing all resolved coordinates and items before they are passed #mty.package[Cetz] for.

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
For keys of states and counters, the use of unique identifiers prevents clashes with other packages or identifiers choens by a user.
If your package is likely to be included more than once in the tree of dependencies a version mismatch between these instances is also possible.
Consider using a unique key across multiple versions of your package.

An example of a unique key would be the following grammar:
```ebnf
key ::= '__' package-name [ ':' package-version ] ':' package-unique-key
```

The leading double underscores `__` ensure that the following key is unlikely to be accidentally used by a user themselves.
A package `pkg` with the version `0.1.0` would only operate on states or counters using keys with the prefix `__pkg:0.1.0`, possible version incompatible changes to the representation of the state are then automatically prevented.
A package may decide if it omits this or maintains a representation which is consistent across multiple versions, using a different mechanism to mark where these are no longer compatible.
The package unique key is unique within the package and can be freely chosen.

Similarly to the keys of counters and states, labels also share a global namespace, once put into the document.
Consider a similar approach for these labels, as well as using names invalid for `@ref` syntax, this ensures that LSPs do not pollute label completions with values which are not meant to be refered to by a user.
An example of this is including whitespace or other non-identifier characters in the key.
A key like `__ pkg:0.1.0:label:backref-anchor` cannot be used in `@ref` syntax and will therefore not be suggested as a completion.
