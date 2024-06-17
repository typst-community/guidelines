#import "/src/util.typ": *
#import mantys: *

= Documentation <sec:style:docs>
#wbox[
  This section documents the syntax of documentation commens, see @sec:api:docs for the contents and purpose of documentation comments.
]

Documentation is placed on special comments using three forward slashes `///` and an optional space.
These are called doc comments.
While the leading space is optional, it is encouraged as it makes the documentaiton easier to read.
Doc comments may not be interrupted by empty lines, markup, or regular comments.

#do-dont[
  ```typst
  /// A1
  /// A2
  /// A3

  // discuraged, but valid
  ///B1
  ///B2
  ///B3
  ```
][
  ```typst
  /// A1
  //
  /// B1

  /// A1

  /// B1

  /// C1
  Hello World
  /// D1

  /**
   * This is a regular comment, not a doc comment.
   */
  #let item = { ... }

  // This is a regular comment, not a doc comment.
  #let item = { ... }
  ```
]

There are two kinds of documentation comments, inner and outer doc comments.
Outer doc comments are placed right above the declaration they are attached to.

#do-dont[
  ```typst
  /// Documentation for func
  #let func() = { ... }

  ```
][
  ```typst
  /// Stray doc comment, not the doc for func

  #let func() = {
    /// Stray doc comment, not the doc for func
    ...
  }

  /// Stray doc comment, not the doc for func
  ```
]

Inner doc comments are used to document modules and must not have a declaration, instead they refer to the file they are placed in and may only be declared once and as the first non comment item in a file.

#do-dont[
  ```typst
  // optional leading comments

  /// Module doc

  /// Function or value doc
  #let item = { ... }
  ```
][
  ```typst
  /// Function or valtion doc
  #let item = { ... }

  /// Stray doc comment, not the module or func doc
  ```
]

Outer doc comments may be used on `let` bindings only.

#do-dont[
  ```typst
  /// Function doc
  #let func() = { ... }

  /// Value doc
  #let value = { ... }
  ```
][
  ```typst
  /// Stray doc comment, markup may not be documented
  Hello World

  /// Stray doc comment, imports my not be documented
  #import "module.typ"

  /// Stray doc comment, scopes may not be documented
  #[
    ...
  ]
  ```
]

Doc comments contain a description of the documented item itself, as well as an optional semantic trailer.
The content of descriptions should generally be simple Typst markup and should not contain any scripting, (i.e. no loops, conditionals or function calls, except for `#link("...")[...]`), this allows the documentation to be turned into Markdown or plaintext or LSP to send to editors.

== Description
As mentioned before, the description should be simple, containing mostly markup and no scripting.

== Semantic Trailer
The semantic trailer is fully optional, starts with an empty doc comment line to separate it from the description, and may contain:
- multiple `term` items for parameter type hints and descriptions,
- a return type hint `-> type`,
- and multiple property annotations (`#property("private")` or `#property("deprecated")`).

Types in type lists or return type annotations may be separated by `|` to indicate that more than one type is accepted, the exact types allowed depend on the doc parser, but the built in types are generally supported.

Parameter description and return types (if present) are placed tightly together, property annotations if present are separated using another empty doc comment line.

Parameter documentation is created by writing a term item containing the parameter name, a mandatory type list in parenthesis and optional description.
If the parameter is an argument sink it's name must also containe the spread operator `..`.
Each parameter can only be documented once, but doesn't have to, undocumented parameters are considered private.

#do-dont[
  ```typst
  /// Function description
  ///
  /// / b (any): b descpription
  /// / a (int | float): a description
  #let func(a, b, c) = { ... }

  /// Function description
  ///
  /// / ..args (int): args description
  #let func(..args) = { ... }
  ```
][
  ```typst
  /// Function description
  ///
  /// / c (any): c doesn't exist
  /// / a (int | float): a description
  #let func(a, b) = { ... }

  /// Missing empty line between function description and trailer
  /// / b (any): b descpription
  /// / a (int | float): a description
  #let func(a, b) = { ... }


  /// Function description
  ///
  /// / b (any): b descpription
  /// / a: missing types
  #let func(a, b) = { ... }

  /// Function description
  ///
  /// / args (int): missing spread operator for args
  #let func(..args) = { ... }
  ```
]

The return type can only be annotated once, on a single line after all parameters if any exist.
For non function types the return type annotation can be used as a normal type annotation.

#do-dont[
  ```typst
  /// Function doc
  ///
  /// / arg (types): Description for arg
  /// -> types
  #let func(arg) = { ... }

  /// Value doc
  ///
  /// -> type
  #let value = { ... }
  ```
][
  ```typst
  /// Missing empty line between description trailer
  ///
  /// -> type
  /// / arg (types): arg descrption after return type
  #let func(arg) = { ... }
  ```
]

Property annotations can be used to document package specific or otherwise important information like deprecation status, visibility or contextuality and may only be used after the return type (if one exists) and an empty doc comment line.

#do-dont[
  ```typst
  /// Function doc
  ///
  /// / arg (types): Description for arg
  /// -> types
  ///
  /// #property("deprecated")
  /// #property("contextual")
  #let func(arg) = { ... }

  /// Value doc
  ///
  /// #property("contextual")
  #let value = { ... }
  ```
][
  ```typst
  /// Missing empty line between return type and properties
  ///
  /// / arg (types): Description for arg
  /// -> types
  /// #property("deprecated")
  /// #property("contextual")
  #let func(arg) = { ... }

  /// Return type after properties and missing empty separation lines
  ///
  /// / arg (types): Description for arg
  /// #property("deprecated")
  /// #property("contextual")
  /// -> types
  #let func(arg) = { ... }
  ```
]
