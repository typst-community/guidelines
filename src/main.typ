#import "packages.typ": mantys
#import "util.typ": chapter,
#import mantys: *

#let doc = toml("/typst.toml").package

#show: mantys(
  ..doc,
  title: "Package API Guidelines",
  subtitle: "Guidelines for Package & Template Development",
  date: datetime.today(),
  abstract: [
    This document contains API guidelines, best practices and patterns to help package and template developers create easy-to-use packages with extensible and interoperable APIs.
  ],
  theme: create-theme(
    fonts: (sans: "TeX Gyre Heros"),
    heading: (font: "TeX Gyre Heros"),
  ),
)

#include "chapters/flexibility.typ"
#include "chapters/simplicity.typ"
#include "chapters/interoperability.typ"
