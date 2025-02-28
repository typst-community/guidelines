#import "/src/util.typ": *
#import mantys: *

#let doc = toml("/typst.toml").package

#show: mantys(
  ..doc,

  title: "API & Style Guidelines",
  subtitle: "Guidelines for Package & Template Development",
  date: datetime(year: 2024, month: 05, day: 01),

  abstract: [
    This document contains stylistic guidelines and API best practices and patterns to help package and template developers create simple to use packages with extensible and interoperable APIs.
    The stylistic guidelines apply to documents in general and make it easier for others to read and contribute to code.
  ],

  // examples-scope: (),
)

#set heading(offset: 1)

#chapter[Manifest]
// TODO

#chapter[Style]
#include "chapters/style.typ"

#chapter[API]
#include "chapters/api.typ"
