#import "/src/util.typ": *
#import mantys: *

= Interoperability
Interoperability of packages is an important part of API design.
The right choice of internal and external functions, states and counters, configurable parameters and hardcoded values are required for a package to be interoperable with others.

== State & Counter Variables
If your package heavily relies on state and counter to track user inputs and/or internal values, consider exposing those as unstable values with appropriate documenttion on how these can be used.
This ensures that a restrictive API exposes an escape hatch to access the inner API without having tomake guarntees about stability.

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
