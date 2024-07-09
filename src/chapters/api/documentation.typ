#import "/src/util.typ": *
#import mantys: *

= Documentation <sec:api:docs>
Documentation comments are important for consumers of the API as well as new contributors to your package or project to understand the usage and purpose of an item.
An item may be a state variable, a counter, a function, a reusable piece of regular content, or anything that can be bound using a `let` statement.

#wbox[
  For the exact syntax used for documentation comments, refer to @sec:style:docs.
]

== Visibility
For public functions the documentation should always include all public parameters, their usage and purpose, as well as possible constraints on their values.
Internal arguments may be omited, if they are not meant to be exposed to a user, but should still be documented for contributors in the source or a contribution document.
Only optional arguments may be internal, required arguments must always be documented and therefore public.

== Defaults
Default values should not be documented if they are simple expressions such as `"default"` or `5`.
If default values refer to more complex expressions or bindings form other modules which are not evident from the context of the documentation, then they should be documented in some way.

#do-dont[
  ```typst
  // - a default is not documented when not necessary
  // - usage of internal default binding default-b is documented and explained

  /// Function doc
  ///
  /// / a (): A doc.
  /// / b (): B doc, defaults to ...
  #let func(a: 5, b: internal.default-b) = { ... }
  ```
][
  ```typst
  // - a default is unecessarily documented
  // - user may not know what the default of b refers to

  /// Function doc
  ///
  /// / a (): A doc, defaults to 5.
  /// / b (): B doc.
  #let func(a: 5, b: internal.default-b) = { ... }
  ```
]

== Annotations
Implicit requirements such as contexts should be documented using property annotations (see @sec:style:docs).
Other annotations may be used to document additional invariants such as visibility or deprecation status.
Consider elaborating on all unconventional uses of property annotations in your documentation.

== Return Values
Functions should also document their return type, even if it is general, such as `any`.
Should a function return different types depending on it's inputs or the state of the document, it must be documented when this may happen or at least which types to expect and check for at the call site.

== States & Counters
Values like states and counters, if exposed, should document their invariants, such as the allowed types for states or the expected depth range of a counter for example.
The type of the value itself should likewise be annotated using the function return type syntax.

#do-dont[
  ```typst
  // - well documented invariants
  // - most doc parsers will identify named defaults, we omit them for brevity
  //   in this example

  /// Does things.
  ///
  /// This function is contextual if `arg` == `other`.
  ///
  /// / arg (int): Fancy arg, must be less than or equal to `other`.
  /// / other (int): Other fancy arg, must be larger than `arg`.
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
  // dictionaries especially can make it hard to get a full grasp of those implicit
  // invariants if they can only inspect the state var in their doc to reverse
  // engineer the definition shape

  /// Contains the function definitions.
  #let item = state("defs", (:))

  // - invariants of `arg` are not documented and may result in poor UX
  // - other is not documented
  // - does not document contexuality

  /// Does things.
  ///
  /// / arg (any): Fancy arg.
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
