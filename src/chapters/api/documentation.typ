#import "/src/util.typ": *
#import mantys: *

= Documentation <sec:api:docs>
Documentaiton comemnts are important for consumers of the API as well as new contributors to your package or project to understand the usage and purpose of an item.
An item may be a state variable, a counter, a function, a reusable piece of regular content, or anything that can be bound using a `let` statement.

#wbox[
  For the exact syntax used for documentation comments, refer to @sec:style:docs.
]

For public functions the documentation should always incldue all public parameters, their usage and purpose as well as possible constraints on their values.
Internal arguments may be ommited, if they are not meant to be exposed to a user, but should still be documented for contributors in the source or a contribution document.
Depending on the doc aprser in use, named arguments may need their defaults explicitly stated and should have if the doc parser can't parse them automatically.
If functions require or return contextual values, this should also be communicated clearly.
Functions should also document their return type, even if it is general, such as `any`.
Should a function return different types depending on it's inputs or the state of the document, it must be documented when this may happen or at least which types to expect and check for at the call site.

Values like states and counters, if exposed, should document their invariants, such as the allowed types for states or the expected depth range of a counter for example.
The type of the value itself should likewise be annotatd using the function return type syntax.

#do-dont[
  ```typst
  // - well documented invariants
  // - most doc parsers will identify named defaults, we omit them for brevity
  //   in this example

  /// Does things.
  ///
  /// This function is contextual if `arg` == `other`.
  ///
  /// - arg (int): Fancy arg, must be less than or equal to `other`.
  /// - other (int): Other fancy arg, must be larger than `arg`.
  /// -> content
  #let func(arg, other: 1) = {
    assert(arg <= other)

    if arg == other {
      context { ... }
    } else {
      ...
    }
  }
  ```
][
  ```typst
  // user don't know how these definitions must be shaped, optional fields on
  // dictionaries especially can make it hard to get a full graps of those implicit
  // invariants if they can only inspect the state var in their doc to reverse
  // engineer the definition shape

  /// Contains the function definitions.
  #let item = state("defs", (:))

  // - invariants of `arg` are not documented and may result in poor UX
  // - other is not documented
  // - does not document contexuality

  /// Does things.
  ///
  /// - arg (any): Fancy arg.
  #let func(arg, other: 1) = {
    // the lack of typing information would cause a hard to understand error
    // message for a novice user
    assert(arg <= other)

    if arg == other {
      context { ... }
    } else {
      ...
    }
  }
  ```
]
