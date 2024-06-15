#import "/src/util.typ": *
#import mantys: *

= Interoperability
Ensuring interoperability between packages is an important part of API design.
Lack of interoperability, especially when it leads to bugs or panics will generally cause users to shy away from using your package.
When designing the API of your package, the following two questions should always be considered for every item of your package's API:

- should this item be public or private?
- should this behavior be configurable or hard coded?

The choice to make an item private or part of a function's behavior hardcoded can negatively impact it's interoperability, but the opposite can lead to bloated and intimidating APIs.

== Visibility
In order to provide other package authors with the ability to write extensions to your package they must usually be able to access cerain internals of your package.
Consider exposing internals in some form to allow users and other developers to escape the high level abstractions your API may impose.

An example of exposed internals serving interoperability is the #mty.package[Fletcher] package, which builds on #mty.package[Cetz].
#mty.package[Fletcher] exposes a simplified API to draw diagrams of all kinds involving arrows.
In order to allow users to draw anything the package itself my not natively support, #mty.package[Fletcher] allows accessing all resolved coordinates before they are passed #mty.package[Cetz] fro drawing through its `render` parameter.

== Configurability
The ability of a user to configure how your API behaves is important to ensure your API flexible.
For example, given a function which queries for and styles elements before a certain label, consider making the label configurable, especially if it is otherwise exposed to the user.

#do-dont[
  ```typst
  #let func() = {
    let selector = internal.func()
    internal.display(query(selector.before(<x>)))
  }
  ```
][
  ```typst
  #let func(label: <x>) = {
    let selector = internal.func()
    internal.display(query(selector.before(label)))
  }
  ```
]

An example of such a type of configurability is the #mty.package[Hydra] package.
Its top level `hydra` function is generally used in page headers, but can be used anywhere on the page if each page contains a `<hydra:anchor>` label before it.
This label is configurable on the `hydra` function itself through its `anchor` parameter to not unconditionally pollute the global label namespace.
If another package for whatever reason generated such a label itself, it would be impossible to use #mty.package[Hydra] alongside it.

== Naming of Global Introspection Elements
For keys of states and counters, use unique identifiers which are unlikely to clash with other packages or project internal identifiers.
If your package is likely to be included more than once in the tree of dependencies a version mismatch is likely.
Consider using a unique key across multiple versions of your package.

An example of a unique key would be the following grammar:
```ebnf
key ::= '__' package-name [ ':' package-version ] ':' package-unique-key
```

The leading double underscores `__` ensure that the following key is unlikely to be accidentally used in the consumer project itself.
The inclusion of the version ensures different keys for mutltiple versions of the same package which may have different invariants on the internal value.
A package may decide if it omits this or maintains an internally consistent representation which is consistent across multiple versions, using a different mechanim to mark where these are no longer compatible.
The package unique key is quniue within the package, the values before that behave like namespaces and package is free to use further namespaces within it's own package unique key.

Similarly to the keys of counters and states, labels also share a global namespace, once put into the document.
Consider a similar approach for these labels, as well as using names invalid for `@ref` syntax, this ensures that LSPs do not pollute label completions with values which are not meant to be refered to by a consumer.
An example of this is including whitespace or other non-identifier characters in the key.
