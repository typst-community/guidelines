#import "/src/util.typ": *
#import mantys: *

= Trailing Content Arguments
Prefer trailing content argument calling style only for single content arguments which happen directly in the document.

#do-dont[
  ```typ
  #link("https://github.com")[github.com]
  ```
][
  ```typ
  // tables are usually more involved, this quickly becomes unweidly and hard to edit
  #table[a][b][c]
  ```
]
