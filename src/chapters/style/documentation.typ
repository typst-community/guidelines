#import "/src/util.typ": *
#import mantys: *

= Documentation <sec:style:docs>
#wbox[
  This section documents the syntax of documentation commens, see @sec:api:docs for the contents and purpose of documentation comments.
]

Documentation for items are placed on comments right before the item, with three forward slashes `///` and a leading space.
The first leading space and comment tokens are stripped of the line and each line is joined to make up the body of the doc comment.
The content of doc comments should be simple Typst markup with some extra documentation specific syntax and assumptions about structure.
Doc comments do not use any other strucutre at this moment, regular comments `//` and `/**/` are ignored by most doc parsers.

#do-dont[
  ```typst
  /// This is a doc comment
  #let item = ...
  ```
][
  ```typst
  /**
   * This is not a doc comment, it's a regular comment.
   */
  #let item = ...

  // This is not a doc comment, it's a regular comment.
  #let item = ...
  ```
]

Doc comments are split into two parts:
- the general description, including examples and package specific sections and the
- optional trailer containing semantic information about the annotated item.

Doc comments may include special syntax such as `@@val` or `@@func()`, these are used by doc generators like #mty.package[Tidy] to generate cross references in documentation.

#wbox[
  There seems to be no special syntax to refer to things other than functions and values at this moment.
]

== Description
The general description makes no assumptions on syntax other than including the aforementioned cross-reference syntax.
It may be any Typst syntax, but should ideally kept simple to allow LSPs to convert it into Markdown for editor hover actions.

== Semantic Trailer
The semantic trailer of doc comments is the last section of the doc comments containing optional information about the documented item.
This may include a list of parameter descriptions, a return type annotation, and other annotations, all of which are not treated as regular Typst syntax.

At this moment #mty.package[Tidy] accepts the following syntax:
```ebnf
param-name          ::= typst-ident
type-name           ::= typst-ident
type                ::= ( '..' )? type-name
type-list           ::= '(' type ( ',' type )+ ')'
description         ::= typst-markup

param-documentation ::= '/// - ' param-name ' ' type-list ':' [description]
return-type         ::= '/// -> ' type-name
```

As well as some other more specific ones like doc tests.
We shall only consider this subset for now.
The trailer may contain zero or more lines of `param-documentation` and an optional `return-type` line.
