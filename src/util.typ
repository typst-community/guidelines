// packages
#import "@preview/mantys:0.1.3"

// helper functions and variables
#let do-dont(do, dont) = {
  mantys.sourcecode(do, title: "Do")
  mantys.sourcecode(dont, title: "Don't")
}

#let mode = (
  mark: raw(lang: "typst", "[markup-mode]"),
  code: raw(lang: "typst", "{code-mode}"),
  math: raw(lang: "typst", "$math-mode$"),
)

#let typst(path, ..body) = text(eastern, link(
  "https://typst.app/" + path.trim("/", at: start),
  body.pos().at(0, default: path),
))
#let docs(path, ..rest) = typst("docs/" + path.trim("/", at: start), ..rest)
#let reference(path, ..rest) = docs("reference/" + path.trim("/", at: start), ..rest)

#let chapter = heading.with(level: 1)
