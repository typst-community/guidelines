// packages
#import "@preview/mantys:1.0.1"

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

#let _link = link
#let link(..args) = text(eastern, _link(..args))

#let discord(..args) = link("https://discord.gg/2uDybryKPe", ..args)

#let typst(path, ..body) = link(
  "https://typst.app/" + path.trim("/", at: start),
  body.pos().at(0, default: path),
)

#let docs(path, ..rest) = typst("docs/" + path.trim("/", at: start), ..rest)
#let reference(path, ..rest) = docs("reference/" + path.trim("/", at: start), ..rest)

#let chapter = heading.with(level: 1)
