#import "/src/util.typ": *
#import mantys: *

= Delimiters
Opening delimiters to unfinished statements like `(...)`, `[...]`, etc. are placed on the same line as their preceding element, e.g. for loops, declarations, etc.
This is actually enforced by the compiler in most cases, as it uses line breaks to terminate most statements.
#do-dont[
  ```typ
  // if it fits on one line avoid linebreaks
  #let var = if { ... }

  // if there's a little more we break K&R style
  #let var = for x in xs [
    ...
  ]

  // likewise, else must be on the same line as the if's closing brace
  #if var {
    // ...
  } else {
    // ...
  }
  ```
][
  ```typ
  // this doesn't parse
  #let var =
  {
  }

  // ask yourself not if you could, but if you should
  #(
    if true
    {
    }
    else
    {
    }
  )
  ```
]
