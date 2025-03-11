#import "packages.typ": mantys

/// Shows a _do_ and a _don't_ box example consecutively.
///
/// -> content
#let do-dont(
  /// The _do_ example box.
  ///
  /// -> content
  do,

  /// The _don't_ example box.
  ///
  /// -> content
  dont,
) = {
  mantys.sourcecode(do, title: "Do")
  mantys.sourcecode(dont, title: "Don't")
}

/// A set of inline markers for the various parsing modes of Typst.
#let mode = (
  mark: raw(lang: "typst", "[markup-mode]"),
  code: raw(lang: "typst", "{code-mode}"),
  math: raw(lang: "typst", "$math-mode$"),
)

/// Links to the Typst community discord.
#let discord(
  /// The body to use instead of the link.
  ///
  /// -> content | none
  ..body,
) = link("https://discord.gg/2uDybryKPe", ..body)

/// Links to the Typst website.
///
/// -> content
#let typst(
  /// The relative path starting at the root of the Typst website.
  ///
  /// -> str
  path,

  /// The optional body to use instead of the path.
  ///
  /// -> content | none
  ..body,
) = link(
  "https://typst.app/" + path.trim("/", at: start),
  body.pos().at(0, default: path),
)

/// Links to the Typst docs page.
///
/// -> content
#let docs(
  /// The relative path starting at Typst docs website.
  ///
  /// -> string
  path,

  /// The optional body to use instead of the path.
  ///
  /// -> content | none
  ..body
) = typst("docs/" + path.trim("/", at: start), ..body)

/// Links to the Typst API reference.
///
/// -> content
#let reference(
  /// The relative path starting at the Typst API reference website.
  ///
  /// -> string
  path,

  /// The optional body to use instead of the path.
  ///
  /// -> content | none
  ..body
) = docs("reference/" + path.trim("/", at: start), ..body)

/// Defines a level one heading.
#let chapter = heading.with(level: 1)
