#import "/src/util.typ": *
#import mantys: *

= Flexibility <sec:api:flex>
Good APIs must be flexible enough to allow users to use them in situations a developer might not have anticipated directly.

== requiring or providing `context`

Starting with Typst 0.11, the #link("https://typst.app/docs/reference/context/")[context] feature allows certain functions to access information about the current location inside the document. The documentation gives the following example:

#example(
  ```typst
  #let value = context text.lang
  #value
  --
  #set text(lang: "de"); #value
  --
  #set text(lang: "fr"); #value
  ```
)

The same `value` is rendered three times, but with different results. This is of course a powerful tool for library authors! However, there is an important restriction that `context` needs to impose to be able to do that: `context` values are opaque content; the above does not result in a string such as `"en"`, it just renders that way:

#example(
  ```typst
  #let value = context text.lang
  Rendered: #value

  Type/representation: #type(value)/#raw(repr(value))
  ```
)

This means that returning a context expression limits what can be done with a function's result. As a rule of thumb, if it's useful for a user to do more with your function than just render its result, you likely want to require the user of your function to use context instead of providing it yourself:

#do-dont[
  ```typst
  /// Returns the current language. This function requires context.
  ///
  /// -> string
  #let fancy-get-language() = { text.lang }

  #context fancy-get-language()

  // Ok: the length of the language code should be 2
  #context fancy-get-language().len()
  ```
][
  ```typst
  /// Returns the current language as opaque content.
  ///
  /// -> content
  #let fancy-get-language() = context { text.lang }

  #fancy-get-language()

  // Doesn't work: type content has no method `len`
  //   #fancy-get-language().len()
  ```
]

The first variant of the `fancy-get-language` function allows the caller to do something with the returned language code (which, with this simplistic function is _necessary_ to do something useful); the latter one can only be rendered.

There are of course exceptions to the rule: requiring using `context` is _a bit_ more complicated to call for users, so if there is no benefit (e.g. the function returns complex content where inspecting it doesn't make sense anyway) it may be more useful to just return opaque content so that the user does not need to think about context.
