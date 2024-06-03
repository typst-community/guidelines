#import "/src/util.typ": *
#import mantys: *

= Mode Switching
Prefer staying in the primary mode of your current context, this avoids unnecessarily frequent use of `#` and unintended leading and trailing whitespace in #mode.mark.
#do-dont[
  ```typst
  // we switched into code mode once and stay in it
  #figure(caption: [...],
    stack(dir: ltr,
      table[...],
      table[...],
    )
  )
  ```
][
  ```typst
  // we switch back and forth, making writing and reading harder
  #figure(caption: [...])[
    #stack(dir: ltr)[
      #table[...]
    ][
      #table[...]
    ]
  ]
  ```
]

Use the most appropriate mode for your top level scopes, if a function has a lot of statements that don't evaluate to content, #mode.code is likely a better choice than #mode.mark.
#do-dont[
  ```typc
  // we have a high ratio of text to code
  let filler = [
    // lots of text
  ]

  // we have a high ratio of code to text
  let computed = if val {
    let x
    let y
    let z
    // ...
  }
  ```
][
  ```typc
  // needless content mode
  let func(a, b, c) = [
    #let as = calc.pow(a, 2)
    #let bs = calc.pow(b, 2)
    #let cs = calc.pow(c, 2)
    #return calc.sqrt(as + bs + cs)
  ]
  ```
]
