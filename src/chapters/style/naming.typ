#import "/src/util.typ": *
#import mantys: *

= Naming
Identifiers use `kebab-case`, i.e. lowercase words separated by hyphens.
Identifiers should be concise, but clear.
Avoid long name with many hyphens for public APIs.
Abbreviations and uncommon names should be avoided or at least clarified when use din public APIs.

#do-dont[
  ```typc
  let name
  let short-name
  ```
][
  ```typc
  let shortname // missing hyphen
  let avn // uncommon abbreviation
  let unnecessarily-long-name // longer than needed
  ```
]
