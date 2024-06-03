#import "/src/util.typ": *
#import mantys: *

= Trailing Content Arguments
Prefer trailing content argument calling style `#func(...)[...]` only for short runs of arguments directly.
Trailing content arguments are harder to visually separate for complex or large amounts of arguments such as tables with multiple rows and make refactoring more noisy in diffs.

#do-dont[
  ```typst
  #link("https://github.com")[github.com]
  #custom[a][b]
  ```
][
  ```typst
  // most tables
  #table[a][b][c]
  ```
]
