#import "/src/util.typ": *
#import mantys: *

= Indentation
Indentation is always 2 spaces per level, tabs can be used to increase accessibility, but spaces and tabs should not be mixed.
For 2 spaces this means that for most syntactic elements, the indentation of nested items or continuations lines up with the start of the first line.
This keeps nested code narrow, allowing side-by-side editing and preview for most users.
#do-dont[
  ```typ
  // consistent easy to follow indentation
  - top level
    - nested
      continuation
  ```
][
  ```typ
  // inconsistent and too deep indentation
  - top level
      - nested
        continued
  ```
]

Likewise, in #mode.code the indentation of scopes is done with 2 spaces.
#do-dont[
  ```typc
  // 2 spaces are generally enough to visually tell levels of indentation apart
  let id(val) = {
    if false {
      panic()
    }
    val
  }
  ```
][
  ```typc
  // ridiculous indentation levels make this quickly hard to read when previewing a document
  let func(val) = {
          if val {
                  // ...
          }
  }
  ```
]

Avoid deep indentation where possible, if a function has multiple code paths that end in simple return values and another which is heavily nested and large, try to invert conditions to decrease nesting.
#do-dont[
  ```typc
  let nested(a, b, c) = {
    if not a {
      return 0
    }
    if not b {
      return 1
    }
    // lots of code ...
  }
  ```
][
  ```typc
  let nested(a, b, c) = {
    if a {
      if b {
        // lots of code ...
      } else {
        1
      }
    } else {
      0
    }
  }
  ```
]
