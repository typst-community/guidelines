#import "/src/util.typ": *
#import mantys: *

= Linebreaks
For documents with a lot of collaboration aided by version control such as git, consider using something similar to #text(eastern, link("https://sembr.org/")[Semantic Line Breaks]).
Avoid hard-wrapping by the editor, as it makes diffs in #mode.mark harder to read.
Typst will maintain the correct linebreaks in both cases.

#do-dont[
  ```typst
  Lorem ipsum dolor sit amet, consectetur adipiscing elit,
  sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
  Nunc non blandit massa enim nec.
  Eu volutpat odio facilisis mauris.
  Velit euismod in pellentesque massa placerat duis ultricies lacus.
```
][
  ```typst
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
  incididunt ut labore et dolore magna aliqua. Nunc non blandit massa enim nec.
  Eu volutpat odio facilisis mauris. Velit euismod in pellentesque massa placerat
  duis ultricies lacus.
  ```
]

#warning-alert[
  Semantic Line Breaking cannot be used for chinese markup at the moment.
]
