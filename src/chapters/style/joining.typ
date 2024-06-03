#import "/src/util.typ": *
#import mantys: *

= Joining
Prefer statement joining over manual joining, this keeps code and markup similar in structure to the end document.
#do-dont[
  ```typst
  // in a document this clearly communicates intent
  #for x in ("a", "b", "c") [
    - #x
  ]
  ```
][
  ```typst
  // this is harder to read and edit
  #let res
  #for x in ("a", "b", "c") {
    res += [- #x]
  }
  #res
  ```
]

Even in #mode.code this can be applied to complex control flows which evaluate to content.
#do-dont[
  ```typc
  // we can read the control flow and it's effect on the document top to bottom
  let func(a, b, c) = {
    [prefix: ]
    a
    if b {
      c
    }
  }
  ```
][
  ```typc
  // even with a low amount of nesting reading this is harder
  let func(a, b, c) = [prefix: ] + a + if b {
    c
  }
  ```
]
