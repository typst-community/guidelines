#import "/src/util.typ": *
#import mantys: *

== Expression Blocks
Prefer implicit block expression values over explicit `return`.
#do-dont[
  ```typc
  let if-none(var, default) = if var == none { default } else { var }
  ```
][
  ```typc
  // useless return
  let if-none(var, default) = if var == none {
    return default
  } else {
    return var
  }
  ```
]

Prefer assignment of expression block expressions over mutation of existing delcarations.
#do-dont[
  ```typc
  let x = if var { 0 } else { 1 }
  ```
][
  ```typc
  let x
  if var {
    x = 0
  } else {
    x = 1
  }
  ```
]

== Expression Blocks
Prefer implicit block expression values over explicit `return`.
#do-dont[
  ```typc
  let if-none(var, default) = if var == none { default } else { var }
  ```
][
  ```typc
  // useless return
  let if-none(var, default) = if var == none {
    return default
  } else {
    return var
  }
  ```
]

Prefer assignment of expression block expressions over mutation of existing delcarations.
#do-dont[
  ```typc
  let x = if var { 0 } else { 1 }
  ```
][
  ```typc
  let x
  if var {
    x = 0
  } else {
    x = 1
  }
  ```
]
