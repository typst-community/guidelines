#import "/src/util.typ": *
#import mantys: *

= Flexibility <sec:api:flex>
Good APIs must be flexible enough to allow users to use them in situations a developer might not have anticipated directly.

== maybe locate

#wbox[This Section is outdated and may be removed in favour of a context section.]

There are several Typst functions that give you access to certain properties of your document via callbacks, among those are #reference("introspection/locate")[`locate`], #reference("foundations/style")[`style`], #reference("layout/layout")[`layout`].
An example of using such a function could look like this:

#example(
  ```typ
  #let body = [Hello]
  #style(styles => [
    #let width = measure(body, styles).width
    The width of "#body" is #width.
    Twice the width would be #(width * 2).
  ])
  ```
)

These functions have in common that they return a `content` value, i.e. the properties (such as measured dimensions) can't escape the callback.
That means that these functions ordinarily don't compose very well.
In particular, the following code that tries to separate calculation and presentation doesn't work as intended:

#example(
  ```typ
  #let get-width(body) = style(styles => {
    measure(body, styles).width
  })

  #let body = [Hello]
  #let width = get-width(body)
  The width of "#body" is #width.
  Twice the width would be #(width * 2) -- oops!

  A length has type #type(0pt),
  but we got a #type(width)!
  ```
)

Especially in a library's public API, that can reduce a function's usefulness.

The "maybe locate" idiom works around that by giving you two options in calling a function:
- either with a callback, just like the "bare" `locate`/`style`/`layout` function, returning `content`; or
- with their respective callback _arguments_, i.e. a `location`, `styles`, or dimension value, returning the actual value.
The name comes from it initially being discussed in relation to the `locate` function, which is common when using the `query` function, but it applies equally to all of these.
Here is its implementation for styles...

```typ
#let maybe-style(func-or-styles, inner) = {
  if type(func-or-styles) == function {
    // a callback was given. Call `style` here and give the result of our `inner`
    // function to the callback. The callback's result will be converted to
    // `content`, if it isn't already one.
    let func = func-or-styles
    style(styles => func(inner(styles)))
  } else {
    // the given value is (hopefully) a `styles` value; use it to call the inner
    // function. No conversion to `content` is necessary.
    let styles = func-or-styles
    inner(styles)
  }
}
```

#let maybe-style(func-or-styles, inner) = {
  if type(func-or-styles) == function {
    let func = func-or-styles
    style(styles => func(inner(styles)))
  } else {
    let styles = func-or-styles
    inner(styles)
  }
}

#block(breakable: false)[
  ... and its application to the example from before:

  #example(
    scope: (maybe-style: maybe-style),
    ```typ
    #let get-width(body, func-or-styles) = {
      maybe-style(func-or-styles, styles => {
        // the inner function is just our calculation
        measure(body, styles).width
      })
    }

    #let body = [Hello]
    // we can call `get-width` with a callback ...
    #get-width(body, width => [
      The width of "#body" is #width.
      Twice the width would be #(width * 2).
    ])

    #style(styles => [
      // ... or with a styles value
      #let width = get-width(body, styles)
      The width of "#body" is #width.
      Twice the width would be #(width * 2).
    ])
    ```
  )
]

Especially the latter variant lets us compose multiple functions requiring `style` without requiring tweaks for a specific case.
The former variant lets us still write code very similar to our initial example, but without having to go through using the `style` function ourselves.
